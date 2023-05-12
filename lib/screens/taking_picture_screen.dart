import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';

import '../shared/ast_cubit/cubit.dart';
import '../shared/ast_cubit/states.dart';
import '../shared/components/Constants.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController controller;
  bool showFocusCircle = false;
  double x = 0;
  double y = 0;
  String text = 'line up the petri dish so that its edges touch the frame';

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.getCubit(context);
    if (!controller.value.isInitialized) {
      return Container();
    }
    return GestureDetector(
        onTapUp: (details) {
          _onTap(details);
        },
        child: BlocConsumer<AppCubit, States>(
          listener: (context, state) async {
            // if(state is UploadImgSuccessState){
            //   print("========================================");
            //   await Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder: (context) => DisplayPictureScreen(
            //         // Pass the automatically generated path to
            //         // the DisplayPictureScreen widget.
            //         //   imagePath: state.imagePath,
            //           // astModel:state.astModel
            //       ),
            //     ),
            //   );
            // }
            // if(state is CreateTestSuccessState){
            //   print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
            //   Fluttertoast.showToast(
            //     msg: "Insertion was successful",
            //     toastLength: Toast.LENGTH_LONG,
            //     gravity: ToastGravity.BOTTOM,
            //     timeInSecForIosWeb: 1,
            //     fontSize: 16,
            //     backgroundColor: Colors.green,
            //     textColor: Colors.white,
            //   );
            //   cubit.cropImage(test_id: cubit.testId!);
            //   navigateTo(context, DisplayPictureScreen());
            // }
          },
          builder: (context, state) => Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Center(child: CameraPreview(controller)),
                if (showFocusCircle)
                  Positioned(
                      top: y - 20,
                      left: x - 20,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 1.5)),
                      )),
                  Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                          ),
                          alignment: Alignment.center,
                          width: 375,
                          height: 400,
                          child: Container(
                            height: 80,
                            color: Colors.black.withOpacity(.5),
                            alignment: Alignment.center,
                            child: Text(
                              text,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ))),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              // Provide an onPressed callback.
              onPressed: () async {
                setState(() {
                  text = "Taking photo...";
                });
                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.
                try {
                  // Ensure that the camera is initialized.
                  await controller;

                  // Attempt to take a picture and get the file `image`
                  // where it was saved.
                  final image = await controller.takePicture();

                    CroppedFile? croppedFile = await ImageCropper().cropImage(sourcePath: image.path);
print(croppedFile!.path);
                    //     .cropImage(sourcePath: image.path, aspectRatioPresets: [
                    //   CropAspectRatioPreset.square,
                    //   CropAspectRatioPreset.ratio3x2,
                    //   CropAspectRatioPreset.original,
                    //   CropAspectRatioPreset.ratio4x3,
                    //   CropAspectRatioPreset.ratio16x9
                    // ], uiSettings: [
                    //   AndroidUiSettings(
                    //       toolbarTitle: 'Cropper',
                    //       toolbarColor: Colors.deepOrange,
                    //       toolbarWidgetColor: Colors.white,
                    //       initAspectRatio: CropAspectRatioPreset.original,
                    //       lockAspectRatio: false),
                    //   IOSUiSettings(
                    //     minimumAspectRatio: 1.0,
                    //   )
                    // ]);

                    cubit.image_path = image.path;
                    AppCubit.getCubit(context).createNewTest(
                        bacteria: cubit.bacteria!,
                        sample_type: cubit.sampleType!,
                        imagePath: image.path);

                  if (!mounted) return;
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ));
  }

  Future<void> _onTap(TapUpDetails details) async {
    if (controller.value.isInitialized) {
      showFocusCircle = true;
      x = details.localPosition.dx;
      y = details.localPosition.dy;

      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * controller.value.aspectRatio;

      double xp = x / fullWidth;
      double yp = y / cameraHeight;

      Offset point = Offset(xp, yp);
      print("point : $point");

      // Manually focus
      await controller.setFocusPoint(point);

      // Manually set light exposure
      //controller.setExposurePoint(point);

      setState(() {
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          setState(() {
            showFocusCircle = false;
          });
        });
      });
    }
  }
}
