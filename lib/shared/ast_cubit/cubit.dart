import 'dart:convert';
import 'dart:typed_data';
import 'package:ast/models/ast_model.dart';
import 'package:ast/models/user_tests_model.dart';
import 'package:ast/shared/ast_cubit/states.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/result_model.dart';
import '../../network/remote/dio_helper.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

import '../components/Constants.dart';

class AppCubit extends Cubit<States> {
  AppCubit() : super(InitialState());

  static AppCubit getCubit(context) => BlocProvider.of(context);

  bool resultReady = false;

  UserTests? userTests;
  void getUserTests() {
    emit(GetTestsLoadingState());
    DioHelper.getData(
      url: USER_TESTS,
      onSuccess: (response) {
        userTests = UserTests.fromJson(response.data);
        emit(GetTestsSuccessState());
      },
      onError: (ApIError) {
        emit(GetTestsErrorState(ApIError.message.toString()));
      },
    );
  }

  String? bacteria;
  String? sampleType;

  String? image_path;
  int? testId;
  void createNewTest({
    required String bacteria,
    required String sample_type,
    required String imagePath,
  }) async {
    testId = 0;
    drawResultImg = null;
    images_info.clear();
    images_id.clear();
    numOfCrops = 0;
    preLabels.clear();
    List<String> c = [
      'Cefepime/clavulanic acid FEC 40',
      'Cefixime CFM 10',
      'Cefditoren CDN 15',
      'Cefmetazole CMZ 20',
      'Cefepime/clavulanic acid FEC 50',
      'Cefixime CFM 20',
      'Cefditoren CDN 51',
      'Cefmetazole CMZ 30'
    ];
    preLabels.addAll(c);
    emit(CreateTestLoadingState());
    DioHelper.postData(
        url: CREATE_TEST,
        data: {
          'bacteria': '$bacteria',
          'sample_type': '$sample_type',
          'file': await MultipartFile.fromFile(imagePath)
        },
        onError: (ApIError) {
          emit(CreateTestErrorState(ApIError.message));
        },
        onSuccess: (response) {
          if (response.data['Status'] == "Sucess") {
            testId = int.parse(response.data['test_id']);
            emit(CreateTestSuccessState());
          } else {
            emit(CreateTestErrorState(response.data['Message']));
          }
        });
  }

  List images_id = [];
  int numOfCrops = 0;
  void cropImage({
    required int test_id,
  }) {
    images_id.clear();
    images_info.clear();
    drawResultImg = null;
    numOfCrops = 0;
    preLabels.clear();
    List<String> c = [
      'Cefepime/clavulanic acid FEC 40',
      'Cefixime CFM 10',
      'Cefditoren CDN 15',
      'Cefmetazole CMZ 20',
      'Cefepime/clavulanic acid FEC 50',
      'Cefixime CFM 20',
      'Cefditoren CDN 51',
      'Cefmetazole CMZ 30'
    ];
    preLabels.addAll(c);

    emit(CropImageLoadingState());
    DioHelper.postData(
      url: PROCESS_CROP,
      data: {
        'test_id': '$test_id',
      },
      onSuccess: (response) {
        print(".......$response");
        numOfCrops = response.data[0]['Num of crops'];
        print(".......");
        if (numOfCrops > 0) {
          images_id = response.data[1];
          emit(CropImageSuccessState());
        } else {
          emit(CropImageErrorState(response.data['Message']));
        }
      },
      onError: (ApIError) {
        print(ApIError.message);
        emit(CropImageErrorState(ApIError.message));
      },
    );
  }

  List<ASTModel> images_info = [];
  List<String> preLabels = <String>[];
  List<TextEditingController> antibioticControllers = [];

  getOneCroppedImage({
    required int img_id,
  }) {
    emit(GetImgLoadingState());

    DioHelper.postData(
        options: Options(responseType: ResponseType.bytes),
        url: FETCH_CROP,
        data: {
          'img_id': img_id,
        },
        onError: (ApIError) {
          print(ApIError.message);
          emit(GetImgErrorState(ApIError.message));
        },
        onSuccess: (response) {
          // Get the image bytes from the response
          Uint8List imageBytes = Uint8List.fromList(response.data);

          Uint8List croppedImg = imageBytes;
          if (croppedImg.isNotEmpty) {
            if (response.headers.value("atb-data") != null) {
              Map<String, dynamic> data =
                  json.decode(response.headers.value("atb-data")!);
              data['img'] = croppedImg;

              images_info.add(ASTModel.fromJson(data));
              preLabels.add(data['label']);
              antibioticControllers.add(TextEditingController());
              if (images_info.length != images_id.length) {
                print("-------------------------------------------------");
                emit(NextState(images_info.length));
              }
              if (images_info.length == images_id.length) {
                emit(GetImgSuccessState());
              }
            }
          } else
            emit(GetImgErrorState(
                'The image id you provided doesn\'t match any stored image id'));
        });
  }

  interpretResults() {
    images_info.forEach((element) {
      var result = 'S';
      if (element.inhibitionRadius! > 60) result = 'R';
      element.result = result;
      ResultModel model = ResultModel(
          img_id: element.imgId, result: element.result, label: element.label);
      results.add(model.toJson());
    });
  }

  PageController controller = PageController(initialPage: 0);

  void changeSlider(index, value) {
    images_info[index].inhibitionRadius = value;
    emit(ChangePageViewIndexState());
  }

  void changeLabel(index, value) {
    images_info[index].label = value;
    emit(ChangePageViewIndexState());
  }

  Uint8List? drawResultImg;
  void drawImage({
    required int test_id,
  }) {
    if (drawResultImg != null)
      emit(DrawImageSuccessState());
    else {
      emit(DrawImageLoadingState());
      DioHelper.postData(
        url: FETCH_DRAW,
        data: {
          'test_id': '$test_id',
        },
        onSuccess: (response) {
          var imageBytes = base64Decode(response.data);

          if (imageBytes.isNotEmpty) {
            drawResultImg = imageBytes;
            emit(DrawImageSuccessState());
          } else
            emit(DrawImageErrorState(
                'The image id you provided doesn\'t match any stored image id'));
        },
        onError: (ApIError) {
          print(ApIError.message);
          emit(DrawImageErrorState(ApIError.message));
        },
      );
    }
  }

  List<Map<String, dynamic>> results = [];

  sendResults() {
    emit(SendResultsLoadingState());
    print(results.toString());
    DioHelper.postData(
        url: TEST_CONFIRM,
        data: {
          'test_id': testId.toString(),
          'image_info': results.toString(),
        },
        onError: (ApIError) {
          print(ApIError.message);
          emit(SendResultsErrorState(ApIError.message));
        },
        onSuccess: (response) {
          print(response.data);
          // if (response.data['Status'] == "Success") {
          emit(SendResultsSuccessState());
          // }
          // else
          //   emit(SendResultsErrorState("TRY AGAIN"));
        });
  }

  List excelDataBacteria = [];
  readBacteriaExcel(cb) async {
    ByteData data = await rootBundle.load('assets/listofbacteria.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    List excelData = [];

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        excelData.add(await row[0]!.value);
      }
    }

    cb(excelData);
  }

  List excelDataSamples = [];
  readSamplesExcel(cb) async {
    ByteData data = await rootBundle.load('assets/Listofspecimens.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    List excelData = [];

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        excelData.add(await row[0]!.value);
      }
    }

    cb(excelData);
  }

  loadExcelData() async {

    await readBacteriaExcel((data) {
      excelDataBacteria = data;
    });

    await readSamplesExcel((data) {
      excelDataSamples = data;
    });

    emit(SearchState());
  }

}
