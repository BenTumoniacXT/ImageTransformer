import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../helpers/helpers.dart';
import 'controller.dart';
import 'logger.dart';

class StableDiffusionTFLite {
  final imgSize = Configs.imgSize();
  final latentSize = Configs.imgSize() ~/ 8;
  final Interpreter diffusionInterpreter;
  final Interpreter textInterpreter;
  final IsolateInterpreter dif;
  final int numThreads;

  StableDiffusionTFLite({
    required this.diffusionInterpreter,
    required this.textInterpreter,
    required this.dif,
    required this.numThreads,
  });

  Future<Uint8List> generateImage(
      String text, int numSteps, int seed) async {
    info(
      "Stable Diffusion model version ${Configs.enableV2 ? "2" : "1.4"}",
    );
    Get.find<T2IControllerV2>().workingProcess.value 
      = "Encoding text";
    final Tensor3dFloat context = await encodeText(text);
    final Tensor3dFloat unconditionalContext = await getUnconditionalContext();
    textInterpreter.close();

    Get.find<T2IControllerV2>().workingProcess.value 
      = "Initializing diffusion noise";

    Tensor4dFloat latent = getInitialDiffusionNoise(
        Configs.batchSize,
        latentSize,
        seed,
      );

    final List<int> timesteps =
        List<int>.generate(numSteps, (index) => index * (1000 ~/ numSteps) + 1);
    final List<List<double>> res = getInitialAlphas(timesteps);
    final List<double> alphas = res[0];
    final List<double> alphasPrev = res[1];

    for (int index = timesteps.length - 1; index >= 0; index--) {
      Get.find<T2IControllerV2>().workingProcess.value 
        = "Processing stage #${numSteps - index}";
      final startTime = DateTime.now().microsecondsSinceEpoch;

      final Tensor4dFloat latentPrev = latent;

      final List<List<double>> tEmb = getTimestepEmbedding(
        timesteps[index],
        Configs.batchSize,
      );

      final unconditionalLatent = await diffusionModel(
        latent,
        tEmb,
        unconditionalContext,
      );

      latent = await diffusionModel(
        latent,
        tEmb,
        context,
      );

      latent = latentMul(
        latent,
        unconditionalLatent,
        Configs.unconditionalGuidanceScale,
      );

      final double aT = alphas[index];
      final double aPrev = alphasPrev[index];

      final Tensor4dFloat predX0 = calculatePredX0(
        latent,
        aT,
        latentPrev,
      );

      latent = calculateUpdatedLatent(latent, aPrev, predX0);
      if (!Configs.showLog && index != 0) {
        Get.find<T2IControllerV2>().updatedLatent.value 
          = await decodeImg(latent, epochIncrement: false);
      }
      final time = DateTime.now().microsecondsSinceEpoch - startTime;
      info(
        "Step ${numSteps - index} took ${(time / 1000000).toStringAsFixed(4)} seconds",
        epochIncrement: true,
      );
    }
    // await dif.close();
    diffusionInterpreter.close();

    Get.find<T2IControllerV2>().workingProcess.value = "Decoding image";
    final ts = await decodeImg(latent);
    return ts;
  }

  Future<Tensor4dFloat> diffusionModel(
    Tensor4dFloat latent,
    List<List<double>> tEmb,
    Tensor3dFloat context,
  ) async {
    final output = outputToTensor4dFloat(
      List.filled(latentSize * latentSize * 4, 0.0).reshape(
        [ 1, latentSize, latentSize, 4 ],
      ),
    );

    await dif.runForMultipleInputs(
      [ latent, context, tEmb ],
      { 0: output, },
    );

    return output;
  }

  Future<Tensor3dFloat> encodeText(String prompt) async {
    final encodedTokens = await encodedTokenPadded(
      prompt,
      Get.find<T2IControllerV2>().tokenizer!,
    );
    final pos = getPosIds();
    final inputs = [encodedTokens, pos];
    final outputTensor = textInterpreter.getOutputTensor(0);

    textInterpreter.runInference(inputs);

    info(
      "Text Encoder Inference took ${textInterpreter.lastNativeInferenceDurationMicroSeconds / 1000000} seconds",
    );
    return outputToTensor3d(
      outputTensor.data.buffer.asFloat32List().reshape(outputTensor.shape),
    );
  }

  Future<Tensor3dFloat> encodeText2(
    List<List<int>> token,
    List<List<int>> pos,
  ) async {
    // token and pos is of shape [1, 77]
    final inputs = [token, pos];

    final outputTensor = textInterpreter.getOutputTensor(0);
    textInterpreter.runInference(inputs);

    info(
      "Text Encoder Inference took ${textInterpreter.lastNativeInferenceDurationMicroSeconds / 1000000} seconds",
      epochIncrement: true,
    );
    return outputToTensor3d(
      outputTensor.data.buffer.asFloat32List().reshape(outputTensor.shape),
    );
  }

  Future<Uint8List> decodeImg(Tensor4dFloat inputData, {bool epochIncrement = true}) async {
    try {
      final inferenceStartNanos = DateTime.now().microsecondsSinceEpoch;
      List<dynamic>? res;
      if (!Configs.decodeOnTFL) {
        const platform = MethodChannel('ort');
        final inferenceOutput = await platform.invokeMethod('decode',
          {
            "inputData": inputData,
            "version": 2,
          },
        ) as List<dynamic>;
        final flattenList = inferenceOutput.flatten();
        res = flattenList
            .map((x) => x! as double)
            .toList()
            .reshape([1, imgSize, imgSize, 3]);
      } else {
        final InterpreterOptions options = InterpreterOptions();
        options.threads = numThreads;
        final imageDecoder = await Interpreter.fromAsset(
          Configs.decoderModelName(),
          options: options
        );
        final imgDecode = await IsolateInterpreter.create(
          address: imageDecoder.address,
        );
        await Future.delayed(const Duration(seconds: 1));
        res = List.filled(imgSize * imgSize * 3, 0.0).reshape([1, imgSize, imgSize, 3]);
        await imgDecode.run(inputData, res);
        imgDecode.close();
      }
      final time = DateTime.now().microsecondsSinceEpoch - inferenceStartNanos;
      debugPrint("Finalizing Image");
      final out = outputToTensor4dFloat(res);
      final Tensor4dInt clipped = clipAndScaleImage(out);

      final Uint8List finalOutput = convertToUint8List(clipped);
      debugPrint("Packaging Image");
      final img.Image dec = img.Image.fromBytes(
        width: imgSize,
        height: imgSize,
        bytes: finalOutput.buffer,
      );
      
      info(
        "Image Decoder Inference took ${(time / 1000000).toStringAsFixed(4)} seconds",
        epochIncrement: epochIncrement,
      );
      return img.encodePng(dec);
    } on Exception catch (e) {
      error('Failed to decode image: $e');
      return Uint8List(0);
    }
  }

  Future<Tensor3dFloat> getUnconditionalContext() async {
    const List<int> unconditionalTokens = UNCONDITIONAL_TOKENS;
    final posIds = getPosIds();
    final Tensor3dFloat unconditionalContext = await encodeText2(
      [unconditionalTokens],
      posIds,
    );
    return unconditionalContext;
  }
}
