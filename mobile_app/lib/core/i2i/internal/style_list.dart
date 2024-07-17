import "dart:io";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_transformer/core/i2i/blocs/i2i_bloc.dart';

class ImageProperties {
  final String filePath;
  final String name;
  String? transformedPath; 

  ImageProperties({required this.filePath, required this.name});
}

class ImageStyleList {
  static final ImageStyleList _instance = ImageStyleList._internal();
  factory ImageStyleList() {
    return _instance;
  }

  bool _initialized = false;
  Future<void> init() async {
    if (_initialized) return;
    for (int i = 0; i < 28; i++) {
      imageList.add(ImageProperties(
        filePath: "assets/style_gallery/style${i + 1}.jpg",
        name: "style${i + 1}")
      );
    }
    _initialized = true;
  }

  Future<void> reset() async {
    for (int i = 0; i < imageList.length; i++) {
      imageList[i].transformedPath = null;
    }
  }

  ImageStyleList._internal();

  List<ImageProperties> imageList = [];

  Widget styleSelectionBuilder({
    required BuildContext appContext,
    required I2IBloc sectionCore,
    required int imageID, 
    required bool selected, 
    required Color borderColor,
    required double frameSize
  }) {
    Widget res;
    switch (imageID) {
      case 0:
        res = Padding(
          padding: !selected 
            ? const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 8)
            : const EdgeInsets.all(0), 
          child: ClipRRect(
            child: InkWell(
              onTap: () async {
                int fromID = -1;
                await showDialog(
                  context: appContext,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Select style image source'),
                      actionsOverflowDirection: VerticalDirection.down,
                      actionsAlignment: MainAxisAlignment.center,
                      actions: <Widget>[
                        Center(child: TextButton(
                          onPressed: () {
                            fromID = 0;
                            Navigator.pop(context);
                          },
                          child: const Text('From device', style: TextStyle(fontSize: 15)),
                        )),
                        Center(child: TextButton(
                          onPressed: () {
                            fromID = 2;
                            Navigator.pop(context);
                          },
                          child: const Text('From internet link', style: TextStyle(fontSize: 15)),
                        )),
                        Center(child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel', style: TextStyle(fontSize: 15)),
                        )),
                      ],
                    );
                  }
                );
                sectionCore.add(
                  LoadStyleImage(
                    loadedImage: null, 
                    fromTarget: fromID, 
                    context: appContext
                  )
                );
              }, // Image tapped
              splashColor: Colors.black87,
              child: Container(
                height: frameSize,
                width: frameSize,
                color: Colors.white,
                child: const Center(child: Icon(Icons.add_photo_alternate)),
              )
            )
          )
        );
        break;
      default:
        res = Padding(
          padding: !selected 
            ? const EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8)
            : const EdgeInsets.all(0),
          child: ClipRRect(
            child: InkWell(
              onTap: () async {
                sectionCore.add(
                  LoadStyleImage(
                    loadedImage: File(imageList[imageID - 1].filePath), 
                    fromTarget: -imageID, 
                    context: appContext
                  )
                );
              },
              splashColor: Colors.black87,
              child: Image(
                image: AssetImage(imageList[imageID - 1].filePath),
                height: frameSize,
                width: frameSize,
                fit: BoxFit.cover,
              )
            )
          )
        );
        break;
    }

    if (selected) {
      return Container(
        height: frameSize,
        width: frameSize + 20,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 8)
        ),
        child: res,
      );
    }

    return res;
  }
}
