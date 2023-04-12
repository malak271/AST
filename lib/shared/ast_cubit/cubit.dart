
import 'dart:io';
import 'dart:typed_data';
import 'package:ast/models/ast_model.dart';
import 'package:ast/shared/ast_cubit/states.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../network/remote/dio_helper.dart';

class AppCubit extends Cubit<States> {
  AppCubit() : super(InitialState());

  static AppCubit getCubit(context) => BlocProvider.of(context);


  ASTModel astModel =ASTModel(cropsDetails: []);

  Uint8List croppedImg=Uint8List.fromList([]);

  List<Uint8List> cropImages=[];

  void uploadImage ({
    required String imagePath,

  }) async{
    cropImages=[];

    emit(UploadImgLoadingState(imagePath));

    DioHelper.postData(
        url: 'http://192.168.1.112:5000/api/cropimage',
        data: {
          // 'file':File(imagePath),
          'file':await MultipartFile.fromFile(imagePath)
          // 'file':File('E:/graduation-project-library/AST-image-processing-master/tests/images/test0_crop')
        },
        onError: (ApIError) {
          print(ApIError.message);
          emit(UploadImgErrorState(ApIError.message));
        },
        onSuccess: (response) {
          print("success");

          // print(response.data);

          astModel=ASTModel.fromJson(response.data);

          // astModel = (response.data as List)
          //     .map((data) => ASTModel.fromJson(data))
          //     .toList();

          // astModel = ASTModel.fromJson(response.data);

          // List<ASTModel> ll=[
          //   ASTModel(radius: 10,label: "LEV5",centerX: 4,centerY: 5,diameter: 5),
          //   ASTModel(radius: 10,label: "IMI10",centerX: 4,centerY: 5,diameter: 5),
          //   ASTModel(radius: 10,label: "MRP10",centerX: 4,centerY: 5,diameter: 5)
          // ];

          // getCroppedImage(img_name: astModel!.cropsDetails![0].imgName??'', img_path: astModel!.cropsDetails![0].imgFolder??'');
          emit(UploadImgSuccessState(astModel,imagePath));
        });
  }



  void getCroppedImage ({
    required String img_name,
    required String img_path,

  }) async{

    emit(GetImgLoadingState());

    DioHelper.postData(
        options:Options(responseType: ResponseType.bytes) ,
        url: 'http://192.168.1.112:5000/sendimg',
        data: {
          'img_name':img_name,
          'img_path':img_path
        },
        onError: (ApIError) {
          print(ApIError.message);
          emit(GetImgErrorState(ApIError.message));
        },
        onSuccess: (response) {
          // Get the image bytes from the response
          Uint8List imageBytes = Uint8List.fromList(response.data);

          // Display the image in the app
          // setState(() {
          //   _image = Image.memory(imageBytes);
          // });

          croppedImg = imageBytes ;
          // cropImages.add(croppedImg);

          if(croppedImg!=null)
            emit(GetImgSuccessState(croppedImg));
          else
            emit(GetImgErrorState('no img in request'));

        });
  }

  PageController controller = PageController(initialPage: 0);

  double radius= 0;




  // int currentIndex = 0;
  void changeSlider(value) {
    radius = value;
    emit(ChangePageViewIndexState());
  }



}