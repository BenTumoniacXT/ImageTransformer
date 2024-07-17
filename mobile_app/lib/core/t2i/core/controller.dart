import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'tokenizer.dart';
import 'stable_diffusion.dart';
import '../helpers/helpers.dart';

class T2IControllerV2 extends GetxController {
  final RxBool showRun = true.obs;
  final RxBool firstRun = true.obs;
  final RxBool loaded = false.obs;
  final RxString displayLog = ''.obs;
  final RxDouble diffusionProgress = 1.0.obs;

  int _reportedStep = 0;
  Rx<String> workingProcess = "".obs;
  Rx<Uint8List> updatedLatent = 
    Uint8List.fromList(
      List.filled(Configs.imgSize() * Configs.imgSize() * 3, 1)
    ).obs;

  Future<void> updateProgress() async {
    _reportedStep += 1;

    if (_reportedStep == int.parse(numSteps!.value.text) + 2) {
      diffusionProgress.value = 1.0;
    } else {
      diffusionProgress.value =
          (100 / (int.parse(numSteps!.value.text) + 2) * _reportedStep) / 100;
    }
  }

  TextEditingController? numThreads;
  TextEditingController? prompt;
  TextEditingController? numSteps;
  TextEditingController? seed;

  Interpreter? diffusionInterpreter;
  Interpreter? textInterpreter;
  IsolateInterpreter? dif;

  Rx<Uint8List> imageData = Uint8List(0).obs;

  Random? random;
  SimpleTokenizer? tokenizer;

  Future<void> init() async {
    firstRun.value = true;
    if (dif != null) dif!.close();
    imageData.value = Uint8List(0);
    displayLog.value = '';
    workingProcess.value = "";
    clearLogs();
  }

  Future<void> generateImg() async {
    showRun.value = false;
    firstRun.value = false;
    diffusionProgress.value = 0.0;
    _reportedStep = 0;
    imageData.value = Uint8List(0);

    workingProcess.value = "Loading models";
    final InterpreterOptions options = InterpreterOptions();
    final int threadsTry = int.tryParse(numThreads!.value.text) ?? 4; 
    options.threads = threadsTry > 8 ? 8 : threadsTry;
    diffusionInterpreter = await Interpreter.fromAsset(
      Configs.diffusionModelName(),
      options: options,
    );
    dif = await IsolateInterpreter.create(
      address: diffusionInterpreter!.address,
    );

    textInterpreter = await Interpreter.fromAsset(
      Configs.textEncoderModelName(),
      options: options,
    );
    await Future.delayed(const Duration(milliseconds: 1000));
    final startTime = DateTime.now().microsecondsSinceEpoch;

    final StableDiffusionTFLite stableDiffusion = StableDiffusionTFLite(
      diffusionInterpreter: diffusionInterpreter!,
      textInterpreter: textInterpreter!,
      dif: dif!,
      numThreads: threadsTry,
    );

    int numberOfSteps = int.tryParse(numSteps!.value.text) ?? 5;
    final Uint8List detailedResult = await stableDiffusion.generateImage(
      prompt!.value.text,
      numberOfSteps,
      int.tryParse(seed!.value.text) ?? 10,
    );
    final time = DateTime.now().microsecondsSinceEpoch - startTime;
    imageData.value = detailedResult;
    showRun.value = true;
    Get.rawSnackbar(
      message:
          "Image Generation took ${(time / 1000000).toStringAsFixed(4)} seconds",
      snackPosition: SnackPosition.TOP,
    );
    update();
  }

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void clearLogs() {
    displayLog.value = '';
  }

  Future shareImg() async {
    final File tempFile = File('${await localPath}/${DateTime.now()}.png');
    await tempFile.writeAsBytes(imageData.value);
    await Share.shareFiles([tempFile.path], text: 'STABLE DIFFUSION');
  }

  @override
  void onInit() {
    super.onInit();
    random = Random();
    prompt = TextEditingController(
      text: textPrompts[random!.nextInt(textPrompts.length)],
    );
    numSteps = TextEditingController(text: '5');
    numThreads = TextEditingController(text: '8');
    seed = TextEditingController(
      text: seedNumbers[random!.nextInt(seedNumbers.length)],
    );
  }

  @override
  Future<void> onReady() async {
    tokenizer = await SimpleTokenizer.createTokenizer(await localPath);
    super.onReady();
    loaded.value = true;
  }

  @override
  void onClose() {
    prompt!.dispose();
    numSteps!.dispose();
    seed!.dispose();
    numThreads!.dispose();
    if (dif != null) dif!.close();

    super.onClose();
  }
}
