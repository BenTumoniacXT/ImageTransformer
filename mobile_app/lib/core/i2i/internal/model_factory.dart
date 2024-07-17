part of 'model_core.dart';

abstract class ModelFactory {
  ModelFactory._();

  static Future<I2IStyleTransfer> getDefaultModel() async {
    return produceModel(I2IModel.defaultModel);
  }

  static Future<I2IStyleTransfer> produceModel(I2IModel modelType) async {
    I2IStyleTransfer modelCore;

    switch (modelType) {
      case I2IModel.defaultModel: 
        modelCore = _NeuralStyleTransfer("");
        break;
      
      case I2IModel.nstMobileNetV2_Float16:
        modelCore = _NeuralStyleTransfer("mobilenetv2_f16");
        break;

      case I2IModel.nstInceptionV3_Float16:
        modelCore = _NeuralStyleTransfer("inceptionv3_f16");
        break;

      case I2IModel.nstMobileNetV2_Int8:
        modelCore = _NeuralStyleTransfer("mobilenetv2_int8");
        break;

      case I2IModel.nstInceptionV3_Int8:
        modelCore = _NeuralStyleTransfer("inceptionv3_int8");
        break;

      case I2IModel.nstMobileNetV2_Core:
        modelCore = _NeuralStyleTransfer("mobilenetv2_core");
        break;

      case I2IModel.nstInceptionV3_Core:
        modelCore = _NeuralStyleTransfer("inceptionv3_core");
        break;

      case I2IModel.nstMobileNetV2_Dynamic:
        modelCore = _NeuralStyleTransfer("mobilenetv2_hybrid");
        break;

      case I2IModel.nstInceptionV3_Dynamic:
        modelCore = _NeuralStyleTransfer("inceptionv3_hybrid");
        break;

      default:
        modelCore = _NeuralStyleTransfer("");
        break;
    }

    return modelCore;
  }
}