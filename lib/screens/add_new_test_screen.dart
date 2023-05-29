import 'package:ast/screens/taking_picture_screen.dart' hide cameras;
import 'package:ast/shared/components/Constants.dart';
import 'package:ast/styles/theme.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dropdown_text_search/dropdown_text_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../shared/ast_cubit/cubit.dart';
import '../shared/ast_cubit/states.dart';
import '../shared/components/components.dart';
import 'package:image_picker/image_picker.dart';
import 'display_picture_screen.dart';

class NewTest extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.getCubit(context);
    TextEditingController sample_controller = TextEditingController();
    TextEditingController bacteria_controller = TextEditingController();

    return BlocConsumer<AppCubit, States>(listener: (context, state) {
      if (state is CreateTestSuccessState) {
        cubit.cropImage(test_id: cubit.testId!);
        navigateTo(context, DisplayPictureScreen());
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text('New test'),
          backgroundColor: MyColor.getColor(),
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
                  mySizedBox20,
                  DropdownTextSearch(
                    onChange: (val){
                      sample_controller.text = val;
                      cubit.sampleType=val;
                    },
                    noItemFoundText: "No results found",
                    controller: sample_controller,
                    overlayHeight: 300.h,
                    items:  cubit.excelDataSamples.map((e) => e.toString()).toList(),
                    filterFnc: (String a,String b){
                      return a.toLowerCase().startsWith(b.toLowerCase());
                    },
                  ),
                  mySizedBox20,
                  Text('Bacteria:'),
                  mySizedBox,
                  DropdownTextSearch(
                    onChange: (val){
                      bacteria_controller.text = val;
                      cubit.bacteria = val;
                    },
                    noItemFoundText: "No results found",
                    controller: bacteria_controller,
                    overlayHeight: 300.h,
                    items:  cubit.excelDataBacteria.map((e) => e.toString()).toList(),
                    filterFnc: (String a,String b){
                      return a.toLowerCase().startsWith(b.toLowerCase());
                    },
                  ),
                  mySizedBox20,
                  Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: myMaterialButton("  IMPORT",Icons.file_upload ,function: () async {
                          if (formKey.currentState!.validate()) {
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            print(pickedFile!.path);
                            if (pickedFile != null) {
                              cubit.image_path = pickedFile.path;
                              AudioPlayer().play(AssetSource('audio/pop.mp3'));
                              AppCubit.getCubit(context).createNewTest(
                                  bacteria: cubit.bacteria!,
                                  sample_type: cubit.sampleType!,
                                  imagePath: pickedFile.path);
                            }
                          }
                        })
                      ),
                      SizedBox(width:.5.w),
                      Expanded(
                          child: myMaterialButton( "  CAPTURE",Icons.camera_alt, function: () {
                            if (formKey.currentState!.validate())
                              navigateTo(
                                  context,
                                  TakePictureScreen(
                                    camera: cameras.first,
                                  ));
                          })
                      ),
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

