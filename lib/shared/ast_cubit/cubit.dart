import 'dart:convert';
import 'dart:typed_data';
import 'package:ast/models/adjustments_model.dart';
import 'package:ast/models/ast_model.dart';
import 'package:ast/models/user_tests_model.dart';
import 'package:ast/shared/ast_cubit/states.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../network/remote/dio_helper.dart';
import '../components/Constants.dart';

class AppCubit extends Cubit<States> {
  AppCubit() : super(InitialState());

  static AppCubit getCubit(context) => BlocProvider.of(context);

  UserTests? userTests;
  void getUserTests(){
    emit(GetTestsLoadingState());
    DioHelper.getData(
      url: 'user/tests',
      onSuccess: (response) {
        userTests=UserTests.fromJson(response.data);
        emit(GetTestsSuccessState());
      },
      onError: (ApIError ) {
        emit(GetTestsErrorState(ApIError.message.toString()));
      },
    );

  }

  String? bacteria;
  String? sampleType;

  String? image_path;
  int? testId;
  void createNewTest ({
    required String bacteria,
    required String sample_type,
    required String imagePath,
  }) async{
    testId=0;
    // image_path=image_path;
    emit(CreateTestLoadingState());
    DioHelper.postData(
        url: 'test/create',
        data: {
          'bacteria': '$bacteria',
          'sample_type': '$sample_type',
          'file':await MultipartFile.fromFile(imagePath)
        },
        onError: (ApIError) {
          print(ApIError.message);
          emit(CreateTestErrorState(ApIError.message));
        },
        onSuccess: (response)  {
          if( response.data['Status']=="Sucess") {
            testId=int.parse(response.data['test_id']);
            emit(CreateTestSuccessState());
          }else{
            emit(CreateTestErrorState(response.data['Message']));
          }
        });
  }

  List images_id=[];
  int numOfCrops=0;
  void cropImage ({
    required int test_id,
  }) {
    images_info.clear();
    numOfCrops=0;
    diameters.clear();
    labels.clear();
    emit(CropImageLoadingState());
    DioHelper.postData(
        url: 'process/crops',
        data: {
          'test_id': '$test_id',
        },
        onSuccess: (response)  {
          print(".......$response");
         numOfCrops= response.data[0]['Num of crops'];
          print(".......");
          if( numOfCrops > 0) {
            images_id=response.data[1];
            emit(CropImageSuccessState());
          }else{
            emit(CropImageErrorState(response.data['Message']));
          }
        } ,
      onError: (ApIError) {
      print(ApIError.message);
      emit(CropImageErrorState(ApIError.message));
    },);
  }

 List<ASTModel> images_info=[];

 getOneCroppedImage ({
    required int img_id,
  }) {

    emit(GetImgLoadingState());

    DioHelper.postData(
        options:Options(responseType: ResponseType.bytes) ,
        url: 'fetch/crop',
        data: {
          'img_id':img_id,
        },
        onError: (ApIError) {
          emit(GetImgErrorState(ApIError.message));
        },
        onSuccess: (response) {
          // Get the image bytes from the response
          Uint8List imageBytes = Uint8List.fromList(response.data);

          Uint8List croppedImg = imageBytes ;

          if(croppedImg.isNotEmpty) {
            if(response.headers.value("atb-data") != null){
              Map<String, dynamic> data=json.decode(response.headers.value("atb-data")!);
              data['img']=croppedImg;
              images_info.add(ASTModel.fromJson(data));
              if(images_info.length != images_id.length) {
                print("-------------------------------------------------");
                print(images_info.length-1);
                emit(NextState(images_info.length));
              }
              if(images_info.length == images_id.length) {
                emit(GetImgSuccessState());
              }
            }
          } else
            emit(GetImgErrorState('The image id you provided doesn\'t match any stored image id'));

        });
  }

 List<Map<String, dynamic>> adjustments=[];

 sendUserAdjustments () {

   print(labels);
   print(diameters);
   print(adjustments);


    if(adjustments.isNotEmpty) {
      emit(SendAdjLoadingState());
      DioHelper.postData(
          options: Options(responseType: ResponseType.bytes),
          url: 'test/confirmation',
          data: {
            'test_id': testId.toString(),
            'image_info': adjustments,
          },
          onError: (ApIError) {
            print(ApIError.message);
            emit(SendAdjErrorState(ApIError.message));
          },
          onSuccess: (response) {
            print(response.data);
            emit(SendAdjSuccessState());
            // if (response.data['Status'] == "Success") {
            //   emit(SendAdjSuccessState());
            // }
            // else
            //   emit(SendAdjErrorState("TRY AGAIN"));
          });
    }else{
      emit(NoAdjChangedState());
    }
  }

  String interprateResults(int img_id){
    if(img_id>415)
      return "S";
    return "R";
  }

  PageController controller = PageController(initialPage: 0);

  List<String> labels = [];
  List<double> diameters = [];

  void changeSlider(index,value) {
    diameters[index]=value;

    int result =adjustments.indexWhere((element) => element['"id"'] == images_info[index].imgId);
    print(result);
    if(result >= 0){
      adjustments[result]["\"radius\""]=diameters[index];
    }else{
      AdjustmentModel model=AdjustmentModel(radius:diameters[index] ,id: images_info[index].imgId);
      adjustments.add(model.toJson());
    }

    emit(ChangePageViewIndexState());

  }

  void changeLabel(index,value){
    labels[index]=value;
    print("$index,$value");
    print(labels);

    // adjustments.clear();

    int result =adjustments.indexWhere((element) => element['"id"'] == images_info[index].imgId);
    print("ressss $result");
    if(result >= 0){
      adjustments[result]["\"label\""]='"'+labels[index]+'"';
    }else{
      AdjustmentModel model=AdjustmentModel(label:'"'+labels[index]+'"' ,id: images_info[index].imgId);
      adjustments.add(model.toJson());
    }

    emit(ChangePageViewIndexState());
  }

  bool isChecked = false;




}