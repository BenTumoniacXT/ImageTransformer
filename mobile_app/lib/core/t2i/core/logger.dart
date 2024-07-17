import 'package:flutter/foundation.dart';

import 'controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

void info(String msg, {String? name, bool epochIncrement = false, String statusLog = ""}) {
  final DateTime now = DateTime.now();
  final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  final String formattedTime = DateFormat('HH:mm:ss.SSS').format(now);
  final String logMessage = "INFO $formattedDate $formattedTime $msg";
  final String logName = name ?? 'STABLE DIFFUSION';
  debugPrint("[INF] $logName: $logMessage");
  Get.find<T2IControllerV2>().displayLog.value += '$logMessage\n \n';
  if (epochIncrement) Get.find<T2IControllerV2>().updateProgress();
}

void error(String msg, {String? name}) {
  final DateTime now = DateTime.now();
  final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  final String formattedTime = DateFormat('HH:mm:ss.SSS').format(now);
  final String logMessage = "ERROR $formattedDate $formattedTime $msg";
  final String logName = name ?? 'STABLE DIFFUSION';
  debugPrint("[ERR] $logName: $logMessage");
}
