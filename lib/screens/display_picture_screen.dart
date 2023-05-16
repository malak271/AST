import 'dart:io';
import 'package:ast/screens/draw_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_size_getter/image_size_getter.dart';
import '../shared/ast_cubit/cubit.dart';
import '../shared/ast_cubit/states.dart';
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
            backgroundColor: HexColor('40A76A'),
          ),
          body: Column(
            children: [
              SizedBox(height: 10,),
              if (state is CropImageLoadingState || state is NextState)
                Expanded(
                  child: Column(
                    children: [
                      // Image.file(File(cubit.image_path!)),
                      Expanded(
                          child: Container(
                              child:
                              Center(child: CircularProgressIndicator()))),
                    ],
                  ),
                ),
              if (cubit.images_id.length > 0 &&
                  cubit.images_info.length == cubit.images_id.length)
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: cubit.controller,
                          itemCount: cubit.numOfCrops + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == cubit.numOfCrops) {
                              return confirmPage(context, cubit);
                            }
                            // if (index == cubit.numOfCrops + 1) {
                            //   // return resultPage(cubit);
                            // }
                            else {
                              return imgPage(cubit, index);
                            }
                          },
                          onPageChanged: (index){
                          },
                          physics: BouncingScrollPhysics(),
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     IconButton(
                      //       icon: Icon(Icons.arrow_back),
                      //       onPressed: () {
                      //         if (AppCubit.getCubit(context)
                      //             .controller
                      //             .page!
                      //             .toInt() >
                      //             0) {
                      //           AppCubit.getCubit(context)
                      //               .controller
                      //               .previousPage(
                      //             duration: Duration(milliseconds: 500),
                      //             curve: Curves.easeInOut,
                      //           );
                      //         }
                      //       },
                      //     ),
                      //     IconButton(
                      //       icon: Icon(Icons.arrow_forward),
                      //       onPressed: () {
                      //         if (AppCubit.getCubit(context)
                      //             .controller
                      //             .page!
                      //             .toInt() <
                      //             2) {
                      //           AppCubit.getCubit(context).controller.nextPage(
                      //             duration: Duration(milliseconds: 500),
                      //             curve: Curves.easeInOut,
                      //           );
                      //         }
                      //       },
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              // if (cubit.numOfCrops==0 )
              //   Center(child: Text("num of crops = 0"))
            ],
          ));
    });
  }

  MyBottomSheet(context, AppCubit cubit) =>
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.circular(25),
            topStart: Radius.circular(25),
          ),
        ),
        builder: (context) =>
            Container(
                height: 601,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DefaultTextFormField(
                                  controller: labelController,
                                  type: TextInputType.text,
                                  validator: (String? value) {
                                    if ((value ?? '').isEmpty) {
                                      return 'label must not be empty';
                                    }
                                  },
                                  text: 'label',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                DefaultTextFormField(
                                  controller: inhibitionController,
                                  type: TextInputType.text,
                                  validator: (String? value) {
                                    if ((value ?? '').isEmpty) {
                                      return 'inhibition radius must not be empty';
                                    }
                                  },
                                  text: 'inhibition radius',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ClipOval(
                                  child: InkWell(
                                    onTap: () {
                                      // cubit.images_info.add(ASTModel(
                                      //     label: labelController.text,
                                      //     inhibitionRadius:
                                      //     double.parse(
                                      //         inhibitionController.text)));
                                      // Fluttertoast.showToast(
                                      //   msg: "antibiotic added successfully",
                                      //   toastLength: Toast.LENGTH_LONG,
                                      //   gravity: ToastGravity.BOTTOM,
                                      //   timeInSecForIosWeb: 5,
                                      //   fontSize: 16,
                                      //   backgroundColor: Colors.green,
                                      //   textColor: Colors.white,
                                      // );
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      color: Colors.green,
                                      width: 50.0,
                                      height: 50.0,
                                      child: Icon(Icons.check,color: Colors.white,),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                )),
      );


  Widget confirmPage(context, AppCubit cubit) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ClipRRect(
            //     borderRadius: BorderRadius.circular(10.0),
            //     child:
            // Image.file(File(cubit.image_path!))),
            SizedBox(height: 10,),
            Text(
                'Has every antibiotic been identified?'),
            Text(
                'Tap next if everything looks good, or add any missing antibiotic'),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: DefaultButton(
                      function: () {
                        MyBottomSheet(context, cubit);
                      },
                      text: '+ ADD MISSING ANTIBIOTIC'),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: DefaultButton(
                      function: () {
                        cubit.drawImage(test_id: cubit.testId!);
                        cubit.interpretResults();
                        navigateTo(context, DrawResultScreen());
                        // cubit.sendUserAdjustments();
                      },
                      text: 'Next'),
                ),
              ],
            ),
          ],
        ),
      );

  Widget resultPage(cubit) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: Text('Antibiotic tested',style: TextStyle(fontWeight: FontWeight.bold),),
                    width: double.infinity,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) =>
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            child: Row(children: [
                              Expanded(
                                  child: Text(cubit.images_info[index].label!)),
                              Expanded(child: Text(cubit.interprateResults(
                                  cubit.images_info[index].imgId!)))
                            ],),
                          ),
                      itemCount: cubit.images_info.length),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: HexColor('40A76A'),
                      ),
                      child: MaterialButton(
                        onPressed: () {},
                        child: Text(
                          "SHARE RESULTS",
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
                        onPressed: () {},
                        child: Text(
                          "BACK",
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
      );

  Widget imgPage(AppCubit cubit, index) {
    print(index);
    Size size = ImageSizeGetter.getSize(
        MemoryInput(cubit.images_info[index].img!));

    double xScale = ((size.width) /
        (cubit.images_info[index].width!));

    double yScale = ((size.height) /
        (cubit.images_info[index].height!));

    double rScale= (xScale + yScale) / 2;

    double radius=cubit.images_info[index].inhibitionRadius! * rScale;

    return Column(
        children: [
          Stack(
            children: [
              Image.memory(
                cubit.images_info[index].img!,
                fit: BoxFit.cover,
              ),
              CustomPaint(
                painter: CirclePainter(
                    x: (cubit.images_info[index]
                        .centerX!) *
                        xScale,
                    y: (cubit.images_info[index]
                        .centerY!) *
                        yScale,
                    radius: radius
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(15),
            width: double.infinity,
            color: Colors.grey,
            child: Text(
                '${index + 1} of ${cubit.numOfCrops}'),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              contentPadding: EdgeInsets.all(4),
            ),
            value: cubit.images_info[index].label,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,
            onChanged: (String? value) {
              cubit.changeLabel(index, value);
            },
            items: cubit.preLabels.map<DropdownMenuItem<String>>(
                    (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
          ),
          SizedBox(
            height: 50,
          ),
          Slider(
            activeColor:  HexColor('40A76A'),
            value: cubit.images_info[index].inhibitionRadius! * rScale ,
            min: 0.0,
            max: cubit.images_info[index].width ?? 0,
            onChanged: (value) {
              cubit.changeSlider(index, value);
            },

          ),
        ],
      );
}
}
