import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final buttonPadding = const EdgeInsets.all(10);
  final headSectionPadding = const EdgeInsets.all(10);
  final midSectionPadding = const EdgeInsets.symmetric(horizontal: 10);

  final buttonStyle = ElevatedButton.styleFrom(
    minimumSize: const Size(160, 160),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  );

  final bool devMode = true;

  Future<void> init() async {}
}
