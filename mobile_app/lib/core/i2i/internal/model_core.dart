import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../utilities/resources.dart';
import 'utilities.dart';

part 'models/nst.dart';
part 'models/stytr2.dart';
part 'model_factory.dart';

abstract class I2IStyleTransfer {
  // Assets folder with the .tflite files
  static const modelDirectory = "assets/models/i2i/";
  final ResourceCenter resCenter = ResourceCenter();

  // Model info
  String name = "";

  I2IStyleTransfer();

  Future<String> transfer(File inputFile, File styleFile, String sessionName);

  Future<bool> close();
}

enum I2IModel { 
  defaultModel("Default", 0),
  nstMobileNetV2_Float16("MobileNetV2 (Float16)", 1),
  nstInceptionV3_Float16("InceptionV3 (Float16)", 2),
  nstMobileNetV2_Int8("MobileNetV2 (Int8)", 3),
  nstInceptionV3_Int8("InceptionV3 (Int8)", 4),
  nstMobileNetV2_Core("MobileNetV2 (Core)", 5),
  nstInceptionV3_Core("InceptionV3 (Core)", 6), 
  nstMobileNetV2_Dynamic("MobileNetV2 (Dynamic)", 7),
  nstInceptionV3_Dynamic("InceptionV3 (Dynamic)", 8);
  //stytr2;
  
  const I2IModel(this.label, this.modelID);
  final String label;
  final int modelID;
}