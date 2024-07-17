import 'dart:typed_data';
import 'package:image/image.dart' as img;

abstract class Utilities {
  static img.Image preprocess(img.Image image, height, width) {
    // Resize to the a given (input) shape
    img.Image transformed = img.copyResize(image, height: height, width: width);
    // Normalize between [0,1]
    transformed = transformed.convert(format: img.Format.float32);
    return transformed;
  }

  static img.Image convertArrayToImage(List<dynamic> imageArray, int inputSize) {
    Uint8List bytes =
      Uint8List.fromList(List.filled(inputSize * inputSize * 3, 0));

    for (int x = 0; x < inputSize; x++) {
      for (int y = 0; y < inputSize; y++) {
        int pixelIndex = (x * inputSize + y) * 3;
        bytes[pixelIndex] = (imageArray[0][x][y][0] * 255).toInt();
        bytes[pixelIndex + 1] = (imageArray[0][x][y][1] * 255).toInt();
        bytes[pixelIndex + 2] = (imageArray[0][x][y][2] * 255).toInt();
      }
    }

    img.Image newImage = img.Image.fromBytes(
      width: inputSize, height: inputSize, bytes: bytes.buffer);

    return newImage;
  }
}