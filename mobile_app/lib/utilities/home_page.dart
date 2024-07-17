import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'info.dart';
import 'home_controller.dart';

import '../core/i2i/start_page.dart';
import '../core/i2i/start_page_alt.dart';
import '../core/i2i/blocs/i2i_bloc.dart';

import '../core/t2i/core/binder.dart';
import '../core/t2i/start_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Style Transformer - ${AppInfo.versionID}'),
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: controller.headSectionPadding,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(
                  color: Colors.blue,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: const Text(
                      'Image Style Transformer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                        height: 1.1,
                      )
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      '${AppInfo.versionID} - ${AppInfo.buildDate}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 2,
                      )
                    ),
                  ),
                ],
              )
            )
          ),
          Expanded(
            child: Padding(
              padding: controller.midSectionPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: controller.buttonPadding,
                        child: ElevatedButton(
                          style: controller.buttonStyle,
                          onPressed: () => {
                            Get.to(
                              () => MultiBlocProvider(
                                providers: [ BlocProvider(create: (context) => I2IBloc()) ],
                                child: const I2IStartPage(),
                              ),
                            )
                          }, 
                          onLongPress: controller.devMode ? () => {
                            Get.to(
                              () => MultiBlocProvider(
                                providers: [ BlocProvider(create: (context) => I2IBloc()) ],
                                child: const I2IStartPageAlt(),
                              ),
                            ),
                          } : null,
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.image),
                              Text("Image to Image", textAlign: TextAlign.center),
                            ],
                          ), 
                        )
                      ),
                      Padding(
                        padding: controller.buttonPadding,
                        child: ElevatedButton(
                          style: controller.buttonStyle,
                          onPressed: (Platform.isWindows || Platform.isMacOS) ? null : () => {
                            Get.to(
                              () => T2IStartPageV2(),
                              binding: T2IBindingV2(),
                            ),
                          },
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.font_download),
                              Text("Text to Image", textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: controller.buttonPadding,
                        child: ElevatedButton(
                          style: controller.buttonStyle,
                          onPressed: () => {}, 
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.image),
                              Text("Self-Generate\nImage", textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: controller.buttonPadding,
                        child: ElevatedButton(
                          style: controller.buttonStyle,
                          onPressed: () => {}, 
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.image),
                              Text("Image with Text\nto Image", textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),*/
                ]
              ) 
            ),
          ),
          Padding(
            padding: controller.headSectionPadding,
            child: const Center(
              child: Text("Created by TumoniacXT Production Studio")
            )
          ),
          const SizedBox(height: 25),
        ],
      )
    );
  }
}
