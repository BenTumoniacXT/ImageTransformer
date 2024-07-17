part of '../model_core.dart';

class _NeuralStyleTransfer extends I2IStyleTransfer {
  // tflite models to be used
  String? _stylePredictor;
  String? _styleTransformer;

  // TensorFlow Lite Interpreter object
  Interpreter? _predictorCore;
  IsolateInterpreter? _predictorInterpreter;
  Interpreter? _transformerCore;
  IsolateInterpreter? _transformerInterpreter;

  int? _inputImageSize;
  int? _styleImageSize;

  // Input and output sizes of each interpreter
  int? _featuresStylizedSize;

  bool _initialized = false;

  _NeuralStyleTransfer(String hyperParameters) {
    if (hyperParameters == "") {
      _stylePredictor = "${I2IStyleTransfer.modelDirectory}df_pred.tflite";
      _styleTransformer = "${I2IStyleTransfer.modelDirectory}df_trans.tflite";
      super.name = "default";
    } else {
      _stylePredictor = "${I2IStyleTransfer.modelDirectory}nst/${(hyperParameters)}_predictor.tflite";
      _styleTransformer = "${I2IStyleTransfer.modelDirectory}nst/${(hyperParameters)}_transformer.tflite";
      super.name = hyperParameters;
    }
  }

  Future<void> loadModel() async {
    _predictorCore = await Interpreter.fromAsset(_stylePredictor!);
    _transformerCore = await Interpreter.fromAsset(_styleTransformer!);

    //_transformerInterpreter = await IsolateInterpreter.create(address: _transformerCore!.address);
    //await Future.delayed(const Duration(seconds: 1));
    //_predictorInterpreter = await IsolateInterpreter.create(address: _predictorCore!.address);
    //await Future.delayed(const Duration(seconds: 1));

    // Save the input/output dimensions of both models to preprocess later the input images
    _inputImageSize = _transformerCore!.getInputTensor(0).shape[1];
    _styleImageSize = _predictorCore!.getInputTensor(0).shape[1];
    _featuresStylizedSize = _predictorCore!.getOutputTensor(0).shape[3];
    resCenter.outputFolder =
        "${(await getTemporaryDirectory()).path}/inferences/";
  }

  @override
  Future<String> transfer(File inputFile, File styleFile, String sessionName) async {
    if (!_initialized) {
      _initialized = true;
      await loadModel();
    }

    String outputFile = "${resCenter.outputFolder}${name}_$sessionName.jpg";
    if (File(outputFile).existsSync()) File(outputFile).deleteSync();

    // Reading images from system
    final timeStart = DateTime.now().microsecondsSinceEpoch;
    img.Image? style;
    if (!await styleFile.exists()) {
      ByteData styleBytes = await rootBundle.load(styleFile.path);
      Uint8List styleUint8 = styleBytes.buffer.asUint8List();
      style = img.decodeImage(styleUint8)!;
    } else {
      style = img.decodeImage(styleFile.readAsBytesSync())!;
    }
    img.Image input = img.decodeImage(inputFile.readAsBytesSync())!;

    // Preprocess the input images
    img.Image processedInput = Utilities.preprocess(input, _inputImageSize, _inputImageSize);
    img.Image processedStyle = Utilities.preprocess(style, _styleImageSize, _styleImageSize);

    // Predicting...
    var styleOutput = List.filled(_featuresStylizedSize!, 0.0)
        .reshape([1, 1, 1, _featuresStylizedSize!]);
     _predictorCore!.run(processedStyle.toUint8List(), styleOutput);

    var transferInputs = [processedInput.toUint8List(), styleOutput];
    var transferOutputs = <int, Object>{};
    var outputData = List.filled(_inputImageSize! * _inputImageSize! * 3, 0.0)
        .reshape([1, _inputImageSize!, _inputImageSize!, 3]);
    transferOutputs[0] = outputData;

    // Transforming...
    _transformerCore!.runForMultipleInputs(transferInputs, transferOutputs);

    // Converting transformation to image
    var outputImage = Utilities.convertArrayToImage(outputData, _inputImageSize!);
    outputImage = img.copyResize(outputImage, width: input.width, height: input.height);

    // Saving results
    await img.encodeImageFile(outputFile, outputImage);
    final timeEnd = DateTime.now().microsecondsSinceEpoch - timeStart;
    debugPrint("${super.name} took ${(timeEnd / 1000000).toStringAsFixed(4)} seconds");
    
    Get.rawSnackbar(
      message: "${super.name} took ${(timeEnd / 1000000).toStringAsFixed(4)} seconds",
      snackPosition: SnackPosition.TOP,
    );
    return outputFile;
  }

  @override 
  Future<bool> close() async {
    if (!_predictorCore!.isDeleted) _predictorCore!.close();
    if (!_predictorCore!.isDeleted) _transformerCore!.close();
    return true;
  }
}