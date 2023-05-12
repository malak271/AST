import 'package:ast/screens/taking_picture_screen.dart' hide cameras;
import 'package:ast/shared/components/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import '../shared/ast_cubit/cubit.dart';
import '../shared/ast_cubit/states.dart';
import '../shared/components/components.dart';
import 'package:image_picker/image_picker.dart';

import 'display_picture_screen.dart';

class NewTest extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var bacteria = [
    'b1',
    'b2',
    'b3',
    'b4',
    'b5',
  ];
  var sampleType = [
    'blood',
    'agar',
  ];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.getCubit(context);
    return BlocConsumer<AppCubit, States>(listener: (context, state) {
      if (state is CreateTestSuccessState) {
        Fluttertoast.showToast(
          msg: "Insertion was successful",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        cubit.cropImage(test_id: cubit.testId!);

        navigateTo(context, DisplayPictureScreen());
        // Navigator.pop(context);
      }
    }, builder: (context, state) {
      return Scaffold(
        // backgroundColor: HexColor("ede3ca"),
        appBar: AppBar(
          title: Text('New test'),
          backgroundColor: HexColor('40A76A'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sample Type:'),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                    menuMaxHeight: 100,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(4),
                    ),
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    onChanged: (String? newValue) {
                      cubit.sampleType = newValue;
                    },
                    items: sampleType
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        alignment: Alignment.centerLeft,
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (String? value) {
                      if ((value ?? '').isEmpty) {
                        return 'sample type must not be empty';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Bacteria:'),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(4),
                    ),
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    onChanged: (String? newValue) {
                      cubit.bacteria = newValue;
                    },
                    items:
                        bacteria.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (String? value) {
                      if ((value ?? '').isEmpty) {
                        return 'bacteria must not be empty';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: HexColor('40A76A'),
                          ),
                          child: MaterialButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  cubit.image_path = pickedFile.path;
                                  AppCubit.getCubit(context).createNewTest(
                                      bacteria: cubit.bacteria!,
                                      sample_type: cubit.sampleType!,
                                      imagePath: pickedFile.path);
                                }
                              }
                            },
                            child: Text(
                              "IMPORT",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: HexColor('40A76A'),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              if (formKey.currentState!.validate())
                                navigateTo(
                                    context,
                                    TakePictureScreen(
                                      camera: cameras.first,
                                    ));
                            },
                            child: Text(
                              "NEXT",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

/*
* DropdownButton<String>(
                          isExpanded: true,
                          items: bacteria.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            cubit.bacteria=newValue;
                          },
                        ),
                        DropdownButton<String>(
                          isExpanded: true,
                          items: sampleType.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            cubit.sampleType=newValue;
                          },
                        ),
                        *
                        *
                        *             bottomNavigationBar: BottomAppBar(
              color: Colors.transparent,
              elevation: 0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                    ),
                    onPressed: () async{
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                      if(pickedFile!=null) {
                        cubit.image_path=pickedFile.path;
                        AppCubit.getCubit(context).createNewTest(
                            bacteria: cubit.bacteria!,
                            sample_type: cubit.sampleType!,
                            imagePath: pickedFile.path);
                      } },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text("IMPORT"),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      navigateTo(context, TakePictureScreen(camera: cameras.first ,));
                    },
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text("NEXT")),
                  ),
                ],
              ),
            ),

* */
