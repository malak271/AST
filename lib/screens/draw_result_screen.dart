import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ast/screens/home_screen.dart';
import 'package:ast/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../shared/ast_cubit/cubit.dart';
import '../shared/ast_cubit/states.dart';
import '../shared/components/components.dart';
import '../shared/components/pdf.dart';

class DrawResultScreen extends StatefulWidget {
  @override
  State<DrawResultScreen> createState() => _DrawResultScreenState();
}

class _DrawResultScreenState extends State<DrawResultScreen> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();

    // Set a timer to change the visibility of the text after 5 seconds
    Timer(Duration(seconds: 4), () {
      setState(() {
        isVisible = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    var cubit = AppCubit.getCubit(context);
    return BlocConsumer<AppCubit, States>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Result'),
              backgroundColor: MyColor.getColor(),
              leading: IconButton(icon:Icon(Icons.arrow_back_ios_outlined),onPressed: (){
                navigateAndFinish(context, HomeScreen());
              },  ),
            ),

            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (state is DrawImageLoadingState)
                      Center(child: AnimatedTextKit(
                        animatedTexts: [
                          FadeAnimatedText('Drawing..'),
                        ],
                        isRepeatingAnimation: true,

                      ),),
                    if (cubit.drawResultImg!=null)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: InteractiveViewer(
                              panEnabled: false, // Set it to false
                              boundaryMargin: EdgeInsets.all(100),
                              minScale: 0.5,
                              maxScale: 2,
                              child: Image.memory(
                                cubit.drawResultImg!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 185.h,
                            child: Visibility(
                              child: Container(width: MediaQuery.of(context).size.width,padding:EdgeInsets.all(8),color: Colors.grey.withOpacity(.5),child: Text("You can Zoom in and out ",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)), //Your widget is gone and won't take up space
                              visible: isVisible,
                            ),
                          ),
                        ],
                      ),
                    if (cubit.drawResultImg!=null)
                      title(),
                    if (cubit.drawResultImg!=null)
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
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(cubit.images_info[index].label!),
                                  Spacer(),
                                  Text(cubit.images_info[index].result!)
                                ],
                              ),
                            ),
                        itemCount: cubit.images_info.length),


                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultButton(
                  function: () {
                    requestPermissions(cubit, context);
                  },
                  text: 'Download AS PDF  ',
                  icon: Icons.save_alt),
            ),
          );
        });
  }

  Widget title()=>Container(
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey,
        width: 1,
      ),
    ),
    child: Text(
      'Antibiotic tested',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    width: double.infinity,
  );
}
