import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'blocs/i2i_bloc.dart';
import 'internal/model_core.dart';

class I2IStartPage extends StatelessWidget {
  const I2IStartPage({super.key});

  void _showBackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure ?'),
          content: const Text(
            'Are you sure you want to leave this page ?'
            '\nYour interference are still going on right now',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController modelOptionController = TextEditingController();
    I2IModel? modelChoice = I2IModel.defaultModel;
    ScrollController scrollControl = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image2Image"),
      ),
      body: BlocBuilder<I2IBloc, I2IState>(
        builder: (context, state) {
          if (state is LoadingContents) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: Text("Loading contents, please wait..."),
              )
            );
          } else if (state is OnStartup) {
            return Column(
              children: [   
                const SizedBox(height: 20),
                DropdownMenu<I2IModel>(
                  initialSelection: I2IModel.defaultModel,
                  controller: modelOptionController,
                  requestFocusOnTap: true,
                  label: const Text('Model option'),
                  onSelected: (I2IModel? selected) {
                    modelChoice = selected;
                  },
                  dropdownMenuEntries: I2IModel.values
                      .map<DropdownMenuEntry<I2IModel>>(
                          (I2IModel model) {
                    return DropdownMenuEntry<I2IModel>(
                      value: model,
                      label: model.label,
                      enabled: true,
                    );
                  }).toList(),
                ),
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Text("Please select an image"),
                    )
                  )
                ),
              ],
            );
          } else {
            return Column(
              children: <Widget>[
                (state is ContentLoaded)
                ? Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Image.file(state.image),
                      )
                    ),
                  )
                : const Expanded(
                    child: Center(
                      child: Icon(Icons.image)
                    )
                  ),
                (state is ContentLoaded) 
                ? Column(
                    children: [ 
                      const Text("Image style list"),
                      Container(
                        margin: const EdgeInsets.all(10),
                        color: Colors.blue[50],
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          color: Colors.blue[50],
                          child: SizedBox(
                            height: I2IBloc.imgSizePreviewLine,
                            child: Scrollbar(
                              controller: scrollControl,
                              child: ListView.separated(
                                controller: scrollControl,
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.all(0),
                                itemCount: context.read<I2IBloc>().imgList.imageList.length + 1, // with Custom Image
                                itemBuilder: (_, i) => context.read<I2IBloc>().imgList.styleSelectionBuilder(
                                  appContext: context,
                                  sectionCore: context.read<I2IBloc>(),
                                  imageID: i,
                                  selected: state.selectedID == i,
                                  borderColor: Colors.blue,
                                  frameSize: I2IBloc.imgSizePreview,
                                ),
                                separatorBuilder: (_, i) => const SizedBox(width: 0),
                              )
                            ),
                          ),
                        )
                      )
                    ],
                  )
                : Container(
                    margin: const EdgeInsets.all(10),
                    color: Colors.blue[50],
                    child: const SizedBox(
                      height: I2IBloc.imgSizePreviewLine + 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: CircularProgressIndicator(),
                          ),
                          Text("Processing image, please wait..."),
                        ]
                      )
                    )
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 10, bottom: 25),
                      child: ElevatedButton.icon(
                        label: const Text("Change image"),
                        icon: const Icon(Icons.change_circle),
                        onPressed: state is ContentLoaded ? () {
                          context.read<I2IBloc>().add(const ExitToHome());
                        } : null, 
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 15, bottom: 25),
                      child: ElevatedButton.icon(
                        label: const Text("Save image"),
                        icon: const Icon(Icons.save_alt),
                        onPressed: (state is ContentLoaded && !(Platform.isWindows || Platform.isMacOS) ) ? () {
                          context.read<I2IBloc>().add(SaveImage(context: context, image: state.image.path));
                        } : null
                      ),
                    )
                  ],
                )
              ]
            );
          }
        },
      ), 
      floatingActionButton: BlocBuilder<I2IBloc, I2IState>(
        builder: (context, state) {
          if (state is OnStartup) {
            return SpeedDial(
              icon: Icons.add_photo_alternate,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.camera_alt),
                  label: 'From camera',
                  onTap: () {
                    context.read<I2IBloc>().add(LoadContentImage(
                      fromTarget: 1, 
                      targetModel: modelChoice!,
                      context: context
                    ));
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.phone_android),
                  label: 'From device',
                  onTap: () {
                    context.read<I2IBloc>().add(LoadContentImage(
                      fromTarget: 0, 
                      targetModel: modelChoice!,
                      context: context
                    ));
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.public),
                  label: 'From weblink',
                  onTap: () {
                    context.read<I2IBloc>().add(LoadContentImage(
                      fromTarget: 2, 
                      targetModel: modelChoice!,
                      context: context
                    ));
                  },
                )
              ],
            );
          } else {
            return Container();
          }
        }
      )
    );
  }
}