import 'dart:io';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utilities/resources.dart';
import '../internal/model_core.dart';
import '../internal/style_list.dart';

part 'i2i_event.dart';
part 'i2i_state.dart';

class I2IBloc extends Bloc<I2IEvent, I2IState> {
  static const double imgSizePreview = 96;
  static const double imgSizePreviewLine = 116;

  File? contentImage;
  String? _transferedImage;
  I2IStyleTransfer? modelCore;
  ImageStyleList imgList = ImageStyleList();
  int targetedID = -1;
  I2IModel? _modelSelection;

  final ResourceCenter resCenter = ResourceCenter();

  I2IBloc() : super(const OnStartup()) {
    on<LoadContentImage>(_loadContentImage);
    on<LoadStyleImage>(_loadStyleImage);
    on<LoadStyleImageLite>(_loadStyleImageLite);
    on<ExitToHome>(_exitToHome);
    on<SaveImage>(_saveImage);

    init();
  }

  void init() {
    contentImage = null;
    _transferedImage = null;
    targetedID = -1;
    if (modelCore != null) modelCore!.close();
    modelCore = null;
  }

  Future<void> saveContent(BuildContext context, String content) async {
    await resCenter.displayImageSavingNameDialog(
        context, await File(content).readAsBytes());
  }

  void _loadContentImage(LoadContentImage event, Emitter<I2IState> emit) async {
    await event.loadImage();
    if (event.loadedImage == null) return;
    emit(const LoadingContents());
    _modelSelection = event.targetModel;
    contentImage = event.loadedImage;
    if (!event.liteMode) {
      await imgList.init();
      await imgList.reset();
    }
    emit(ContentLoaded(image: contentImage!, selectedID: targetedID));
  }

  Future<String?> _styleTransfer(File? styleImage, int fromTarget) async {
    String contentName = basename(contentImage!.path);
    modelCore = await ModelFactory.produceModel(_modelSelection!);
    _transferedImage = await modelCore?.transfer(
        contentImage!, styleImage!, "${contentName}_style$fromTarget");
    modelCore!.close();

    return _transferedImage;
  }

  Future<void> _loadStyleImage(LoadStyleImage event, Emitter<I2IState> emit) async {
    await event.loadImage();
    if (event.loadedImage == null) return;

    emit(const TransferWorking());

    if (event.fromTarget == 0) {
      _transferedImage =
          await _styleTransfer(event.loadedImage, event.fromTarget);
    } else {
      if (imgList.imageList[event.fromTarget - 1].transformedPath == null) {
        imgList.imageList[event.fromTarget - 1].transformedPath =
            await _styleTransfer(event.loadedImage, event.fromTarget);
      }

      _transferedImage =
          imgList.imageList[event.fromTarget - 1].transformedPath;
    }

    emit(ContentLoaded(
        image: File(_transferedImage!), selectedID: event.fromTarget));
  }

  Future<void> _loadStyleImageLite(
      LoadStyleImageLite event, Emitter<I2IState> emit) async {
    await event.loadImage();
    if (event.loadedImage == null) return;

    emit(const TransferWorking());
    _transferedImage =
        await _styleTransfer(event.loadedImage, event.fromTarget);
    emit(TransferCompleted(imageCore: _transferedImage!));
  }

  void _exitToHome(ExitToHome event, Emitter<I2IState> emit) {
    init();
    emit(const OnStartup());
  }

  void _saveImage(SaveImage event, Emitter<I2IState> emit) async {
    await saveContent(event.context, event.image);
  }
}
