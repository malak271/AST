import 'dart:convert';
import 'package:ast/screens/add_new_test_screen.dart';
import 'package:ast/screens/draw_result_screen.dart';
import 'package:ast/screens/login_screen.dart';
import 'package:ast/shared/ast_cubit/cubit.dart';
import 'package:ast/styles/theme.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/ast_model.dart';
import '../models/user_tests_model.dart';
import '../shared/ast_cubit/states.dart';
import '../shared/components/Constants.dart';
import '../shared/components/components.dart';
import 'display_picture_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.getCubit(context);
    cubit.getUserTests();
    return Scaffold(
        backgroundColor: MyColor.getBackGroundColor(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            cubit.loadExcelData();
            navigateTo(context, NewTest());
          },
          icon: const Icon(Icons.edit),
          label: const Text('New Test'),
          backgroundColor: MyColor.getColor(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBar(
          backgroundColor: MyColor.getColor(),
          titleSpacing: 0,
          title: Text('My Tests:'),
          leading: Icon(Icons.arrow_back_ios_outlined),
          actions: [
            GestureDetector(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.logout,size: 35,),
            ),onTap: (){
              cookie=null;
              navigateAndFinish(context, LoginScreen());
            },)
          ],
        ),
        body: BlocConsumer<AppCubit, States>(
          listener: (context, state) => {},
          builder: (context, state) {
            return ConditionalBuilder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: itemBuilder(context, cubit),
                );
              },
              condition: state is GetTestsSuccessState,
              fallback: (BuildContext context) =>
                  Center(child: CircularProgressIndicator()),
            );
          },
        ));
  }

  Widget itemBuilder(context, AppCubit cubit) {
    if(cubit.userTests!.testsCount ==0 )
      return const Center(child: Text('There are no tests yet.'),);
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ListView.separated(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => buildCardItem(
                      cubit.userTests!.data![index], context, cubit),
                  separatorBuilder: (context, index) => mySizedBox,
                  itemCount: cubit.userTests!.testsCount ?? 0),
              mySizedBox20,
            ],
          ),
        ),
      );

  }

  Widget buildCardItem(Data test, context, AppCubit cubit) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: CARD_DECORATION,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildRowItem('Sample type: ',test.sampleType),
                buildRowItem('Bacteria:  ', test.bacteria),
                buildRowItem('Created at: ', test.createdAt,maxLines: 3),
                Row(
                  children: [
                    Icon(
                      test.mobileResult != null
                          ? Icons.check_box
                          : Icons.timelapse_outlined,
                      color:test.mobileResult!=null? Colors.green:Colors.blue,
                    ),
                    Text(
                        ' ${test.mobileResult != null ? 'completed' : 'not completed'}',style: TextStyle(color: Colors.black54,fontSize: 12),)
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            cubit.testId=test.id;
            if (test.mobileResult != null) {
              Iterable l = json.decode(test.mobileResult!);
              List<ASTModel> results =
              List<ASTModel>.from(l.map((model) => ASTModel.fromJson(model)));
              cubit.images_info = results;

              if(test.processedImage != null){
                cubit.drawImage(test_id: cubit.testId!);
                cubit.resultReady=true;
                navigateTo(context, DrawResultScreen());
              }
              // else
              // navigateTo(context, TestResultScreen());
            }else  if (test.mobileResult == null) {
               cubit.cropImage(test_id: cubit.testId!);
               navigateTo(context, DisplayPictureScreen());
            }
          },
        ),
  );

  Widget buildRowItem(title,text,{maxLines=1})=>Row(
    children: [
      Text(title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12.sp),),
      Text(
        '$text',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12.sp),
      ),
    ],
  );
}
