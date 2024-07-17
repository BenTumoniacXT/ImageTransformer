part of 'i2i_bloc.dart';

abstract class I2IEvent extends Equatable {
  const I2IEvent();

  @override
  List<Object> get props => [];
}

class _LoadImage extends I2IEvent {
  final imagePicker = ImagePicker();
  final ResourceCenter resCenter = ResourceCenter();
  final BuildContext context;

  _LoadImage({required this.context});

  bool retryOption = false;
  Future<void> _retryDialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Downloading Error!'),
            content: const Text(
              'Your image is failed to download from internet\n'
              'Would you like to try again ?',
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
                  retryOption = true;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  // Get image from a source.
  // -  0 mean Internal Storage
  // -  1 is from the device Camera
  Future<File?> getImage({int fromTarget = 0}) async {
    dynamic image;
    switch (fromTarget) {
      case 0:
        image = await imagePicker.pickImage(
          source: ImageSource.gallery,
        );
        break;

      case 1:
        image = await imagePicker.pickImage(
          source: ImageSource.camera,
        );
        break;

      case 2:
        await resCenter.displayImageLinkDialog(context);
        String? imageLink = resCenter.returnImageLinkAndReset();

        if (imageLink != null) {
          bool downloaded = false;

          while (!downloaded) {
            resCenter.displayInfiniteLoading(context,
                message: "Downloading image, please wait...");
            try {
              String fileName = basename(Uri.parse(imageLink).path);
              Response contentBytes = await Dio().get(imageLink,
                  options: Options(
                    responseType: ResponseType.bytes,
                    sendTimeout: const Duration(milliseconds: 15000),
                    receiveTimeout: const Duration(milliseconds: 15000),
                  ));

              String pathName =
                  "${(await getTemporaryDirectory()).path}/$fileName";
              image = File(pathName);
              var writer = image.openSync(mode: FileMode.write);
              writer.writeFromSync(contentBytes.data);
              await writer.close();
              downloaded = true;
              Navigator.pop(context);
            } catch (e) {
              Navigator.pop(context);
              debugPrint(e.toString());

              await _retryDialog(context);
              if (retryOption) {
                retryOption = false;
              } else {
                image = null;
                break;
              }
            }
          }
        }
        break;

      default:
        break;
    }

    if (image == null) return null;
    return File(image.path);
  }
}

class LoadContentImage extends _LoadImage {
  File? loadedImage;
  final int fromTarget;
  final I2IModel targetModel;
  final bool liteMode;

  Future<void> loadImage() async {
    loadedImage = await getImage(fromTarget: fromTarget);
  }

  LoadContentImage({
    required this.fromTarget,
    required this.targetModel,
    required super.context,
    this.liteMode = false
  }) : super();
}

class LoadStyleImageLite extends _LoadImage {
  File? loadedImage;
  int fromTarget;

  Future<void> loadImage() async {
    loadedImage = await getImage(fromTarget: fromTarget);
  }

  LoadStyleImageLite({required this.fromTarget, required super.context}) : super();
}

class LoadStyleImage extends _LoadImage {
  File? loadedImage;
  int fromTarget;

  Future<void> loadImage() async {
    if (fromTarget < 0) {
      fromTarget = fromTarget.abs();
      return;
    }
    loadedImage = await getImage(fromTarget: fromTarget);
    if (fromTarget > 0) {
      fromTarget = 0;
    }
  }

  LoadStyleImage({this.loadedImage, required this.fromTarget, required super.context}) : super();
}

class ExitToHome extends I2IEvent {
  const ExitToHome();
}

class SaveImage extends I2IEvent {
  final String image;
  final BuildContext context;

  const SaveImage({required this.context, required this.image});
}
