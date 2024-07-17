import 'package:flutter/material.dart';
import 'package:image_transformer/core/t2i/helpers/helpers.dart';

class T2ISettingPage extends StatefulWidget {
  const T2ISettingPage({super.key});

  @override
  State<StatefulWidget> createState() => _T2ISettingState();
}

class _T2ISettingState extends State<T2ISettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
      body: Column(
        children: <Widget>[
          CheckboxListTile(
            title: const Text("Use Stable Diffusion v2 instead (allow better image quality but required more hardware resources)"),
            controlAffinity: ListTileControlAffinity.leading,
            value: Configs.enableV2,
            onChanged: (bool? value) {
              setState(() {
                Configs.enableV2 = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text("Show Log instead of Diffusion Evolution"),
            controlAffinity: ListTileControlAffinity.leading,
            value: Configs.showLog,
            onChanged: (bool? value) {
              setState(() {
                Configs.showLog = value!;
              });
            },
          ),  
        ],
      )
    );
  }
}

