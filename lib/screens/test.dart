/*
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(
    camera: firstCamera,
  ));
}

class MyApp extends StatefulWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  double _zoomLevel = 1.0;
  bool _flashOn = false;
  bool _autoFocusOn = true;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    if (_flashOn) {
      await _controller.setFlashMode(FlashMode.off);
      setState(() {
        _flashOn = false;
      });
    } else {
      await _controller.setFlashMode(FlashMode.torch);
      setState(() {
        _flashOn = true;
      });
    }
  }

  void _toggleAutoFocus() {
    setState(() {
      _autoFocusOn = !_autoFocusOn;
    });
  }

  void _onZoomUpdate(double zoom) {
    setState(() {
      _zoomLevel = zoom;
    });
    _controller.setZoomLevel(_zoomLevel);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Camera App'),
        ),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraMlVision<List<Face>>(
                detector: FaceDetector(),
                onZoomUpdate: _onZoomUpdate,
                overlayBuilder: (c) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _toggleFlash,
                            child: Text(_flashOn ? 'Flash On' : 'Flash Off'),
                          ),
                          ElevatedButton(
                            onPressed: _toggleAutoFocus,
                            child:
                            Text(_autoFocusOn ? 'Auto Focus On' : 'Auto Focus Off'),
                          ),
                        ],
                      ),
                      Text('Zoom Level: ${_zoomLevel.toStringAsFixed(2)}'),
                    ],
                  );
                },
                cameraLensDirection: CameraLensDirection.back,
                cameraController: _controller,
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
*/
// import 'dart:async';
// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
//
// class TakePictureScreen extends StatefulWidget {
//   final CameraDescription camera;
//
//   const TakePictureScreen({Key? key, required this.camera}) : super(key: key);
//
//   @override
//   _TakePictureScreenState createState() => _TakePictureScreenState();
// }
//
// class _TakePictureScreenState extends State<TakePictureScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//
//   double _zoomLevel = 1.0;
//   bool _flashOn = false;
//   bool _autoFocusOn = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(
//       widget.camera,
//       ResolutionPreset.medium,
//     );
//
//     _initializeControllerFuture = _controller.initialize();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Future<void> _toggleFlash() async {
//     if (_flashOn) {
//       await _controller.setFlashMode(FlashMode.off);
//       setState(() {
//         _flashOn = false;
//       });
//     } else {
//       await _controller.setFlashMode(FlashMode.torch);
//       setState(() {
//         _flashOn = true;
//       });
//     }
//   }
//
//   void _toggleAutoFocus() {
//     setState(() {
//       _autoFocusOn = !_autoFocusOn;
//     });
//   }
//
//   void _onZoomUpdate(double zoom) {
//     setState(() {
//       _zoomLevel = zoom;
//     });
//     _controller.setZoomLevel(_zoomLevel);
//   }
//
//   void _onResult(List<dynamic> data) {
//     print('Detected data: $data');
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Camera App'),
//         ),
//         body: FutureBuilder<void>(
//           future: _initializeControllerFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               return CameraMlVision<List<Face>>(
//                 onResult: _onResult,
//                 detector: FaceDetector(),
//                 onZoomUpdate: _onZoomUpdate,
//                 overlayBuilder: (c) {
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           ElevatedButton(
//                             onPressed: _toggleFlash,
//                             child: Text(_flashOn ? 'Flash On' : 'Flash Off'),
//                           ),
//                           ElevatedButton(
//                             onPressed: _toggleAutoFocus,
//                             child:
//                             Text(_autoFocusOn ? 'Auto Focus On' : 'Auto Focus Off'),
//                           ),
//                         ],
//                       ),
//                       Text('Zoom Level: ${_zoomLevel.toStringAsFixed(2)}'),
//                     ],
//                   );
//                 },
//                 cameraLensDirection: CameraLensDirection.back,
//                 cameraController: _controller,
//               );
//             } else {
//               return const Center(child: CircularProgressIndicator());
//             }
//           },
//         ),
//       );
//   }
// }




// // A widget that displays the picture taken by the user.
// import 'dart:io';
//
// import 'package:ast/shared/ast_cubit/cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
// import '../models/ast_model.dart';
// import '../shared/ast_cubit/states.dart';
//
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;
//   final List<ASTModel> astModel;
//
//   DisplayPictureScreen(
//       {super.key, required this.imagePath, required this.astModel});
//
//   PageController controller = PageController();
//
//   // List<Widget> _list = <Widget>[
//   //   new Center(
//   //       child: new Pages(
//   //     text: astModel[0].name,
//   //   )),
//   //   new Center(
//   //       child: new Pages(
//   //     text: "Page 2",
//   //   )),
//   //   new Center(
//   //       child: new Pages(
//   //     text: "Page 3",
//   //   )),
//   //
//   // ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AppCubit, States>(
//       listener: (context,state){},
//       builder:(context,state)=> Scaffold(
//         appBar: AppBar(
//             title: const Text(
//               'Display the Picture',
//               style: TextStyle(color: Colors.green),
//             )),
//         // The image is stored as a file on the device. Use the `Image.file`
//         // constructor with the given path to display the image.
//         body: Column(
//           children: [
//             Container(height:MediaQuery.of(context).size.height * 0.5,width:double.infinity,child: Image.file(File(imagePath))),
//             // Text(astModel[0].name ?? ''),
//             // Text(astModel[1].name ?? ''),
//             // Text(astModel[2].name ?? ''),
//             Expanded(
//               child: Container(
//                 color: Colors.black,
//                 child: PageView(
//                   children:[
//                     //16 page view
//                     Container(
//                       color: Colors.red,
//                       child: PageView( //2 children
//                         children: [ new Center(
//                             child: new Pages(
//                               text: astModel[0].name,
//                             )),
//                           new Center(
//                               child: new Pages(
//                                 text: astModel[1].name,
//                               )),
//                         ],
//                         scrollDirection: Axis.horizontal,
//                         // reverse: true,
//                         // physics: BouncingScrollPhysics(),
//                         controller: controller,
//                         onPageChanged: (num) {
//                           AppCubit.getCubit(context).changePageViewIndex(num);
//                         },
//                       ),
//                     ),
//                     Container(
//                       color: Colors.green,
//                       child: PageView(
//                         children:  [ new Center(
//                             child: new Pages(
//                               text: 'hi',
//                             )),
//                           new Center(
//                               child: new Pages(
//                                 text: 'hi2',
//                               )),
//                         ],
//                         scrollDirection: Axis.horizontal,
//                         // reverse: true,
//                         // physics: BouncingScrollPhysics(),
//                         controller: controller,
//                         onPageChanged: (num) {
//                           AppCubit.getCubit(context).changePageViewIndex(num);
//                         },
//                       ),
//                     ),
//                   ] ,
//                   scrollDirection: Axis.horizontal,
//                   // reverse: true,
//                   // physics: BouncingScrollPhysics(),
//                   controller: controller,
//                   onPageChanged: (num) {
//                     AppCubit.getCubit(context).changePageViewIndex(num);
//                   },
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.arrow_back),
//                   onPressed: () {
//                     if (controller.page!.toInt() > 0) {
//                       controller.previousPage(
//                         duration: Duration(milliseconds: 500),
//                         curve: Curves.easeInOut,
//                       );
//                     }
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.arrow_forward),
//                   onPressed: () {
//                     if (controller.page!.toInt() < 2) {
//                       controller.nextPage(
//                         duration: Duration(milliseconds: 500),
//                         curve: Curves.easeInOut,
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//         //Image.file(File(imagePath)), //AppCubit.getCubit(context).
//       ),
//     );
//   }
// }
//
// class Pages extends StatelessWidget {
//   final text;
//   Pages({this.text});
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               text,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//             ),
//           ]),
//     );
//   }
// }
