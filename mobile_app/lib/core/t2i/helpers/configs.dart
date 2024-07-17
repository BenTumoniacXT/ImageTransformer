class Configs {
  static int imgSize() {
    return enableV2 ? 768 : 512;
  }

  static String modelDirectory() {
    return enableV2 ? 'assets/models/t2i/diffusion/main/v2/' 
      : 'assets/models/t2i/diffusion/main/v1/';
  }

  static String diffusionModelName() {
    return "${modelDirectory()}diffusion_model.tflite";
  }

  static String textEncoderModelName() {
    return "${modelDirectory()}text_encoder.tflite";
  }

  static String decoderModelName() {
    return "${modelDirectory()}decoder.tflite";
  }

  static bool enableV2 = false;
  static const batchSize = 1;
  static const unconditionalGuidanceScale = 7.5;
  static const decodeOnTFL = false;
  static bool showLog = false;
}