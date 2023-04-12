// A widget that displays the picture taken by the user.

import 'dart:io';
import 'dart:typed_data';
import 'package:ast/shared/ast_cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/ast_model.dart';
import '../shared/ast_cubit/states.dart';
import '../shared/components/circle_painter.dart';
import 'package:image_size_getter/image_size_getter.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen(
      {super.key, required this.imagePath });

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}
final PageController _controller = PageController(initialPage: 0);

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  late Uint8List croppedImg;
  late ASTModel astModel;
  double _radius = 20;
  //newCoordinate = oldCoordinate * (newImageSize / oldImageSize)


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, States>(listener: (context, state) {
      if (state is UploadImgSuccessState) {
        astModel=state.astModel;
        AppCubit.getCubit(context).getCroppedImage(
            img_name: state.astModel.cropsDetails![0].imgName ?? "",
            img_path: state.astModel.cropsDetails![0].imgFolder ?? "");
      }

      if (state is GetImgSuccessState) {
        croppedImg = state.croppedImg;
      }

    }, builder: (context, state) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Result'),
          ),
          body: Column(
            children: [
              if (state is UploadImgLoadingState)
                Expanded(
                  child: Column(
                    children: [
                      Image.file(File(widget.imagePath)),
                      Expanded(
                          child: Container(
                              child: Center(child: CircularProgressIndicator()))),
                    ],
                  ),
                ),
              if(state is GetImgSuccessState)
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: astModel.analysedCrops,
                          itemBuilder: (BuildContext context, int index) {
                            print("hhhhhhhhhhhhhhhhhhhhhhhhhhhh");
                            print(index);
                            Size size=ImageSizeGetter.getSize(MemoryInput(croppedImg));
                            double xScale = ((size.width) /( astModel.cropsDetails![index].width!));
                            double yScale = ((size.height) / ( astModel.cropsDetails![index].height!));
                            // double newRadius = _radius * (xScale + yScale) / 2;

                            return Column(
                              children: [
                                Stack(
                                  children: [
                                    Image.memory(croppedImg!),
                                    CustomPaint(
                                      painter: CirclePainter(
                                        x: ( astModel.cropsDetails![index].centerX!) * xScale,
                                        y: ( astModel.cropsDetails![index].centerY!) * yScale,
                                        radius: _radius,
                                      ),
                                    ),
                                  ],
                                ),
                                Slider(
                                  value: _radius,
                                  min: 10.0,
                                  max: 100.0,
                                  onChanged: (value) {
                                    setState(() {
                                      _radius = value;
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                          onPageChanged: (index) {
                            print("++++++++++++++++++++++++++++++++++++++");
                            print(index);
                            AppCubit.getCubit(context).getCroppedImage(
                                img_name: astModel.cropsDetails![index].imgName!,
                                img_path: astModel.cropsDetails![index].imgFolder!);
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              if (_controller.page!.toInt() > 0) {
                                _controller.previousPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: () {
                              if (_controller.page!.toInt() < 2) {
                                _controller.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            ],
          ));
    });
  }
}
