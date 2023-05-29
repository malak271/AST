import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ast/screens/add_new_test_screen.dart';
import 'package:ast/screens/draw_result_screen.dart';
import 'package:ast/styles/theme.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_size_getter/image_size_getter.dart';
import '../shared/ast_cubit/cubit.dart';
import '../shared/ast_cubit/states.dart';
import '../shared/components/Constants.dart';
import '../shared/components/circle_painter.dart';
import '../shared/components/components.dart';

class DisplayPictureScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var labelController = TextEditingController();
  var inhibitionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.getCubit(context);

    return BlocConsumer<AppCubit, States>(listener: (context, state) {
      if (state is CropImageSuccessState) {
        cubit.getOneCroppedImage(img_id: cubit.images_id[0]);
      }
      if (state is NextState) {
        cubit.getOneCroppedImage(img_id: cubit.images_id[state.index]);
      }
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Result'),
          backgroundColor: MyColor.getColor(),
        ),
        bottomNavigationBar: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if( state is CropImageErrorState)
              DefaultButton(function: (){navigateAndFinish(context, NewTest());}, text: 'BACK'),
            if(state is! CropImageErrorState)
            Container(
              color: Colors.grey.withOpacity(.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      if (AppCubit.getCubit(context).controller.page!.toInt() > 0) {
                        AppCubit.getCubit(context).controller.previousPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                      }
                    },
                  ),
                  Divider(color: Colors.white),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      if (cubit.controller.page!.toInt() <
                          cubit.images_info.length - 1) {
                        AppCubit.getCubit(context).controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                      } else if (cubit.controller.page!.toInt() ==
                          cubit.images_info.length - 1) {
                        AudioPlayer().play(AssetSource('audio/pop.mp3'));
                        AlertDialog alert = AlertDialog(
                          content: Text(
                              'Tap finish if everything looks good, or cancel'),
                          actions: [
                            Row(
                              children: [
                                Expanded(
                                  child: DefaultButton(
                                      function: () {
                                        cubit.drawImage(test_id: cubit.testId!);
                                        cubit.interpretResults();
                                        cubit.sendResults();
                                        navigateAndFinish(
                                            context, DrawResultScreen());
                                      },
                                      text: 'finish ',
                                      icon: Icons.done),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  child: DefaultButton(
                                      function: () {
                                        Navigator.pop(context);
                                      },
                                      text: 'cancel ',
                                      icon: Icons.cancel),
                                ),
                              ],
                            ),
                          ],
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            if (state is CropImageLoadingState || state is NextState)
              LoadingPage(cubit),
            if (cubit.images_id.length > 0 &&
                cubit.images_info.length == cubit.images_id.length)
              Expanded(
                child: Column(
                  children: [
                    ConditionalBuilder(
                      condition:cubit.numOfCrops>0 ,
                      fallback:(BuildContext context)
                           {
                             navigateAndFinish(context, NewTest());
                             return Text('No antibiotics founded.');
                           } ,
                      builder:(BuildContext context)=> Expanded(
                        child: PageView.builder(
                          controller: cubit.controller,
                          itemCount: cubit.numOfCrops,
                          itemBuilder: (BuildContext context, int index)=>imgPage(cubit, index, context),
                          onPageChanged: (index) {},
                          physics: BouncingScrollPhysics(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if( state is CropImageErrorState)
               Center(child: Text('No antibiotics founded.'))
          ],
        ),
      );
    });
  }

  Widget LoadingPage(cubit) => Column(
        children: [
          Container(height:400.h,width:double.infinity,child: Image.file(File(cubit.image_path!),fit: BoxFit.cover,)),
          SizedBox(
            height: 20.h,
          ),
          AnimatedTextKit(
            animatedTexts: [
              FadeAnimatedText('Analysis running..'),
            ],
            isRepeatingAnimation: true,
          ),
        ],
      );

  Widget imgPage(AppCubit cubit, index, context) {
    Size size =
        ImageSizeGetter.getSize(MemoryInput(cubit.images_info[index].img!));

    double xScale = ((400.0.w) / (cubit.images_info[index].width!));

    double yScale = ((400.0.h) / (cubit.images_info[index].height!));

    double rScale = (xScale + yScale) / 2;

    double radius = cubit.images_info[index].inhibitionRadius! * rScale;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 400.h,
                width: 400.w,
                child: Image.memory(
                  cubit.images_info[index].img!,
                  fit: BoxFit.cover,
                ),
              ),
              CustomPaint(
                painter: DashedCirclePainter(
                    color: Colors.white,
                    strokeWidth: 3.0,
                    dashLength: 8.0,
                    gapLength: 5.0,
                    x: (cubit.images_info[index].centerX!) * xScale,
                    y: (cubit.images_info[index].centerY!) * yScale,
                    radius: radius),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(15),
            width: double.infinity,
            color: Colors.grey.withOpacity(.8),
            child: Text('${index + 1} of ${cubit.numOfCrops}',
                style: TextStyle(
                  color: Colors.black54,
                )),
          ),
          title('Check antibiotic name:'),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonFormField<String>(
              decoration: dropdownButtonDecoration,
              value: cubit.images_info[index].label,
              style: TextStyle(color: Colors.black54),
              elevation: 16,
              onChanged: (String? value) {
                cubit.changeLabel(index, value);
              },
              menuMaxHeight: 300.h,
              items:
                  cubit.preLabels.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                );
              }).toList(),
            ),
          ),
          mySizedBox20,
          title('Adjust inhibation zone:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              sliderButton(
                Icons.remove,
                    () {
                  cubit.changeSlider(
                      index, cubit.images_info[index].inhibitionRadius! - 1);
                },
              ),
              Container(
                width: 250.w,
                child: Slider(
                  activeColor: MyColor.getColor(),
                  value: cubit.images_info[index].inhibitionRadius!,
                  min: 0.0,
                  max: cubit.images_info[index].width ?? 0,
                  onChanged: (value) {
                    cubit.changeSlider(index, value);
                  },
                ),
              ),
              sliderButton(
                Icons.add,
                () {
                  cubit.changeSlider(
                      index, cubit.images_info[index].inhibitionRadius! + 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget sliderButton(IconData icon, Function function) => GestureDetector(
        onTap: (){function();},
        child: Container(
          height: 40.h,
          width: 40.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: MyColor.getColor()),
          ),
          child: Icon(
            icon,
            color: Colors.green,
          ),
        ),
      );

  Widget title(text)=>Padding(
    padding: const EdgeInsets.only(left: 8.0, bottom: 15),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.black87,
      ),
    ),
  );
}
