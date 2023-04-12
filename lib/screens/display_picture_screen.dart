import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_size_getter/image_size_getter.dart';
import '../shared/ast_cubit/cubit.dart';
import '../shared/ast_cubit/states.dart';
import '../shared/components/circle_painter.dart';

class DisplayPictureScreen extends StatefulWidget {

  DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);


  final String imagePath;

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  double radius=0;

  @override
  Widget build(BuildContext context) {
    const List<String> list = <String>['Cefepime/clavulanic acid FEC 40', 'Cefixime CFM 10', 'Cefditoren CDN 15', 'Cefmetazole CMZ 20','Cefepime/clavulanic acid FEC 50', 'Cefixime CFM 20', 'Cefditoren CDN 51', 'Cefmetazole CMZ 30'];

    return BlocConsumer<AppCubit, States>(listener: (context, state) {
      if (state is UploadImgSuccessState) {
        AppCubit.getCubit(context).getCroppedImage(
            img_name: AppCubit.getCubit(context).astModel.cropsDetails[0].imgName!,
            img_path: AppCubit.getCubit(context).astModel.cropsDetails[0].imgFolder!);
      }

      if(state is GetImgSuccessState){
        AppCubit.getCubit(context).cropImages.add(state.croppedImg);
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
              if(AppCubit.getCubit(context).cropImages.length > 0)
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: AppCubit.getCubit(context).controller,
                          itemCount:  AppCubit.getCubit(context).astModel.analysedCrops,
                          itemBuilder: (BuildContext context, int index) {
                            Size size = ImageSizeGetter.getSize(
                                MemoryInput(AppCubit
                                    .getCubit(context)
                                    .cropImages[index]));
                            double xScale = ((size.width) / (AppCubit
                                .getCubit(context)
                                .astModel
                                .cropsDetails[index].width!));
                            double yScale = ((size.height) / (AppCubit
                                .getCubit(context)
                                .astModel
                                .cropsDetails[index].height!));

                            // AppCubit
                            //     .getCubit(context)
                            //     .radius = ((AppCubit
                            //     .getCubit(context)
                            //     .astModel
                            //     .cropsDetails[index].diameter!) *
                            //     (xScale + yScale) / 2);

                            // radius=((AppCubit
                            //         .getCubit(context)
                            //         .astModel
                            //         .cropsDetails[index].diameter!) *
                            //         (xScale + yScale) / 2);

                            String dropdownValue=list.first;
                            // setState(() {
                            //   list.add(AppCubit.getCubit(context).astModel.cropsDetails[index].label??'');
                            //   String dropdownValue = list.last;
                            // });



                            // AppCubit.getCubit(context).radius=AppCubit.getCubit(context).astModel.cropsDetails[index].atbRadius??20;
                            // double newRadius = _radius * (xScale + yScale) / 2;

                            return Column(
                              children: [
                                Stack(
                                  children: [
                                    Image.memory(AppCubit
                                        .getCubit(context)
                                        .cropImages[index],
                                      fit: BoxFit.cover,),
                                    CustomPaint(
                                      painter: CirclePainter(
                                          x: (AppCubit
                                              .getCubit(context)
                                              .astModel
                                              .cropsDetails[index].centerX!) *
                                              xScale,
                                          y: (AppCubit
                                              .getCubit(context)
                                              .astModel
                                              .cropsDetails[index].centerY!) *
                                              yScale,
                                          radius: radius
                                        // radius: AppCubit
                                        //     .getCubit(context)
                                        //     .radius //(AppCubit.getCubit(context).astModel.cropsDetails[index].diameter!)* (xScale + yScale) / 2,
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
                                      '${index + 1} of ${AppCubit
                                          .getCubit(context)
                                          .astModel
                                          .analysedCrops}'
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      contentPadding: EdgeInsets.all(4),

                                    ),
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    elevation: 16,
                                    onChanged: (String? value) {
                                      // dropdownValue=value??'';
                                    },
                                    items: list.map<
                                        DropdownMenuItem<String>>((
                                        String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(height: 50,),
                                Slider(
                                  value: radius,
                                  min: 10.0,
                                  max: 100.0,
                                  onChanged: (value) {
                                    // AppCubit.getCubit(context).changeSlider(
                                    //     value);
                                    setState(() {
                                      print(radius);
                                      radius=value;
                                      print(radius);
                                    });
                                  },
                                ),
                              ],
                            );

                          },
                          onPageChanged: (index) {
                            // save the new radius
                            print(AppCubit.getCubit(context).cropImages.length);
                            if(AppCubit.getCubit(context).cropImages.length<=index)
                              AppCubit.getCubit(context).getCroppedImage(
                                  img_name: AppCubit.getCubit(context).astModel.cropsDetails[index].imgName!,
                                  img_path: AppCubit.getCubit(context).astModel.cropsDetails[index].imgFolder!);
                          },
                          physics:BouncingScrollPhysics() ,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              if (AppCubit.getCubit(context).controller.page!.toInt() > 0) {
                                AppCubit.getCubit(context).controller.previousPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: () {
                              if (AppCubit.getCubit(context).controller.page!.toInt() < 2) {
                                AppCubit.getCubit(context).controller.nextPage(
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
