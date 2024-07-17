import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class ResourceCenter {
  static final ResourceCenter _instance = ResourceCenter._internal();
  factory ResourceCenter() { return _instance; }

  final TextEditingController _stringTextFieldController = TextEditingController();
  
  bool _imageSavingDialogState = false;
  bool returnImageSavingStateAndReset() {
    bool clone = _imageSavingDialogState;
    _imageSavingDialogState = false;
    return clone;
  }
  Future<void> displayImageSavingNameDialog(BuildContext context, Uint8List content) async {
  returnImageSavingStateAndReset();
  _stringTextFieldController.clear();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Your image name: ', style: TextStyle(fontSize: 20)),
          content: TextField(
            controller: _stringTextFieldController,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Save'),
              onPressed: () async {
                try {
                  if (await requestPermission(Permission.storage)) {
                    await saveImage(content, name: _stringTextFieldController.value.text);
                    _imageSavingDialogState = true;
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }

  String? _imageLink;
  String? returnImageLinkAndReset() {
    String? clone = _imageLink;
    _imageLink = null;
    return clone;
  }
  Future<void> displayImageLinkDialog(BuildContext context) async {
  returnImageLinkAndReset();
  _stringTextFieldController.clear();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Your image link: ', style: TextStyle(fontSize: 20)),
          content: TextField(
            controller: _stringTextFieldController,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Download'),
              onPressed: () async {
                _imageLink = _stringTextFieldController.value.text;
                if (_imageLink == "" || _imageLink == null) {
                  _imageLink = "https://i.ytimg.com/vi/qGk4E9ss95s/maxresdefault.jpg";
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }

  Future<void> displayInfiniteLoading(BuildContext context, {String message = "Loading contents, please wait..."}) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(20),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              Container(margin: const EdgeInsets.symmetric(horizontal: 15), child: Text(message)),
            ],
          ),
        );
      }
    );
  }

  Future<void> _asyncInit() async {
    Directory tempDir = await getTemporaryDirectory();
    outputFolder = path.join(tempDir.path, "imgTemp");
  }
  
  ResourceCenter._internal() {
    _asyncInit();
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<void> saveImage(Uint8List content, {String name = "UntitledImage", String format = "png"}) async {
    if (format == "png") {
      await ImageGallerySaver.saveImage(
        content.buffer.asUint8List(),
        quality: 100,
        name: name,
      );
    } else {
      debugPrint("Cannot save in $format");
    }
  }

  late String outputFolder;
}