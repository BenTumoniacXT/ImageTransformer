import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:io';
import 'blocs/i2i_bloc.dart';
import 'internal/model_core.dart';

class I2IStartPageAlt extends StatelessWidget {
  const I2IStartPageAlt({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController modelOptionController = TextEditingController();
    I2IModel? modelChoice = I2IModel.defaultModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image2Image - LabMode"),
      ),
      body: BlocBuilder<I2IBloc, I2IState>(
        builder: (context, state) {
          if (state is OnStartup) {
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
          } else if (state is ContentLoaded) {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 20,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Image.file(state.image),
                    )
                  )
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 10, top: 15, bottom: 15),
                        child: ElevatedButton.icon(
                          label: const Text("Change image"),
                          icon: const Icon(Icons.image),
                          onPressed: () => {
                            context.read<I2IBloc>().add(const ExitToHome())
                          }, 
                        ),
                      )
                    ),
                    Expanded(
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 15, top: 15, bottom: 15),
                        child: ElevatedButton.icon(
                          label: const Text("Load style"),
                          icon: const Icon(Icons.image),
                          onPressed: () async {
                            context.read<I2IBloc>().add(LoadStyleImageLite(fromTarget: 0, context: context));
                          }
                        ),
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            );
          } else if (state is TransferCompleted) {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.file(File(state.imageCore)),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 10, top: 15, bottom: 15),
                        child: ElevatedButton.icon(
                          label: const Text("New image"),
                          icon: const Icon(Icons.imagesearch_roller),
                          onPressed: () {
                            context.read<I2IBloc>().add(const ExitToHome());
                          }, 
                        ),
                      )
                    ),
                    Expanded(
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 15, top: 15, bottom: 15),
                        child: ElevatedButton.icon(
                          label: const Text("Save image"),
                          icon: const Icon(Icons.save_alt),
                          onPressed: (Platform.isWindows || Platform.isMacOS) ? null : () {
                            context.read<I2IBloc>().add(SaveImage(context: context, image: state.imageCore));
                          }
                        ),
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            );
          } else if (state is TransferWorking) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Container(
                    margin: const EdgeInsets.only(left: 15), 
                    child: const Text("Processing image, please wait...")
                  ),
                ],
              )
            );
          } else {
            return const Center(
              child: Text("This program is unloaded!")
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
                    context.read<I2IBloc>().add(
                      LoadContentImage(
                        fromTarget: 1, 
                        targetModel: modelChoice!, 
                        context: context, 
                        liteMode: true
                      )
                    );
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.phone_android),
                  label: 'From device',
                  onTap: () {
                    context.read<I2IBloc>().add(
                      LoadContentImage(
                        fromTarget: 0, 
                        targetModel: modelChoice!, 
                        context: context, 
                        liteMode: true
                      )
                    );
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.public),
                  label: 'From weblink',
                  onTap: () {
                    context.read<I2IBloc>().add(
                      LoadContentImage(
                        fromTarget: 2, 
                        targetModel: modelChoice!, 
                        context: context, 
                        liteMode: true
                      )
                    );
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