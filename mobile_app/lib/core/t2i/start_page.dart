import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_transformer/core/t2i/setting_page.dart';

import '../../../utilities/resources.dart';
import 'core/controller.dart';
import 'shared/log_widget.dart';
import 'helpers/helpers.dart';

class T2IStartPageV2 extends GetView<T2IControllerV2> {
  final ResourceCenter resCenter = ResourceCenter();
  T2IStartPageV2({super.key});

  Future<void> _confirmDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('WARNING!'),
          content: const Text(
            'For better experince, please make sure to reduce '
            'background tasks as much as possible.\n'
            '\n'
            'Do you want to continue ?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
                controller.generateImg();
              },
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text2Image'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: Colors.black,
            onPressed: () {
              Get.to(() => const T2ISettingPage());
            },
          ),
          const Padding(padding: EdgeInsets.only(right: 3)),
        ],
      ),
      body: Column(
        children: <Widget>[
          Obx(() => Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: controller.prompt,
                  decoration: const InputDecoration(
                    label: Text('Enter the messages'),
                  ),
                  maxLines: 4,
                  enabled: controller.firstRun.value,
                  //enabled: controller.showRun.value,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 145,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: TextField(
                        controller: controller.numSteps,
                        decoration: const InputDecoration(
                          label: Text('Number of stages'),
                        ),
                        keyboardType: TextInputType.number,
                        enabled: controller.firstRun.value,
                        //enabled: controller.showRun.value,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: TextField(
                        controller: controller.seed,
                        decoration: const InputDecoration(
                          label: Text('Seed ID'),
                        ),
                        keyboardType: TextInputType.number,
                        enabled: controller.firstRun.value,
                        //enabled: controller.showRun.value,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 165,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 20),
                      child: TextField(
                        controller: controller.numThreads,
                        decoration: const InputDecoration(
                          label: Text('Number of threads'),
                        ),
                        keyboardType: TextInputType.number,
                        enabled: controller.firstRun.value,
                        //enabled: controller.showRun.value,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
          Expanded(
            child: Obx(
              () => controller.imageData.value.length > 1
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10), 
                    child: Image.memory(
                      controller.imageData.value,
                      height: Configs.imgSize().toDouble(),
                      width: Configs.imgSize().toDouble(),
                      fit: BoxFit.contain,
                    )
                )
                : !controller.showRun.value
                  ? Configs.showLog ? LogWidget(
                      text: controller.displayLog.value,
                    )
                    : Padding(
                        padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10), 
                        child: Image.memory(
                          controller.updatedLatent.value,
                          height: Configs.imgSize().toDouble(),
                          width: Configs.imgSize().toDouble(),
                          fit: BoxFit.contain,
                        )
                      )
                  : Container()
            ),
          ),
          Obx(
            () => controller.diffusionProgress.value == 1.0
                ? controller.firstRun.value
                    ? controller.loaded.value 
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                            child: ElevatedButton.icon(
                              label: const Text("Execute"),
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () async {
                                await _confirmDialog(context);
                              },
                            ),
                          ),
                        )
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("Loading contents, please wait...")
                          )
                        )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 10),
                            child: ElevatedButton.icon(
                              label: const Text("Start Over"),
                              icon: const Icon(Icons.restart_alt),
                              onPressed: () async { await controller.init(); },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 10),
                            child: ElevatedButton.icon(
                              label: const Text("Save image"),
                              icon: const Icon(Icons.save_alt),
                              onPressed: () async {
                                await resCenter.displayImageSavingNameDialog(context, controller.imageData.value);
                              },
                            ),
                          ),
                        ],
                      )
                : Column(
                    children: [
                      Text("Executing: ${controller.workingProcess}..."),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 20),
                          child: LinearProgressIndicator(
                            value: controller.diffusionProgress.value,
                          )
                        )
                      )
                    ],
                  ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
