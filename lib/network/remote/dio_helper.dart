import 'dart:io';
import 'package:ast/shared/components/Constants.dart';
import 'package:dio/dio.dart';

class DioHelper {

  static  Dio dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.1.110:5000/',
      receiveDataWhenStatusError: true,
      headers:
      {
        'Content-Type':'application/json',
        'cookie':cookie
      },
    followRedirects: false,
    maxRedirects: 5,
  ));


  /// parameters:
  /// onSuccess(Response): it is a callback function which will performs after getting data from api,
  /// then you can use this data.
  /// onError(ApIError): you can handle any type of errors in this method
  static  getData({
    required String url,
    Map<String,dynamic>? query,
    String lang='ar',
    String? authorization,
    required Function(Response) onSuccess,
    required Function(ApIError) onError,
  }) async {
    try{
      dio.options.headers= {
        'Content-Type':'application/json',
        'cookie':cookie
      };
      Response data= await dio.get(url,queryParameters: query ?? null,);
      onSuccess(data);
    }on DioError catch(error){
      onError(ApIError(error.message,error.response));
    }on SocketException catch(error){
      onError(ApIError('لا يوجد اتصال بالانترنت',null));
    } catch(error){
      onError(ApIError(error.toString(),null));
    }
  }

  /// parameters:
  /// onSuccess(Response): it is a callback function which will performs after post data to url api,
  /// then you can use this data.
  /// onError(ApIError): you can handle any type of errors in this method
  static postData({
    required String url,
    required dynamic data,
    String lang='en',
    String? authorization,
    Map<String,dynamic>? query,
    required Function(Response) onSuccess,
    required Function(ApIError) onError,
    Options? options
  }) async {
    dio.options.headers= {
      'Content-Type':'application/json',
      'cookie':cookie
    };
    dio.options.followRedirects=false;
    dio.options.maxRedirects=5;
    dio.options.validateStatus=(status) { return (status??200) < 500; };

    try {

      //formdata
      var formData = FormData.fromMap(data);
      Response response = await dio.post(url, data: formData ,options:options );
      onSuccess(response);

    }on DioError catch(error){
      onError(ApIError(error.message,error.response));
    }on SocketException catch(error){
      print(error.message.toString());
      onError(ApIError('no internet connection',null));
    }catch(error){
      onError(ApIError(error.toString(),null));
    }
  }


  static putData({
    required String url,
    Map<String,dynamic>? data,
    String lang='en',
    String? authorization,
    Map<String,dynamic>? query,
    required Function(Response) onSuccess,
    required Function(ApIError) onError,
  }) async {
    dio.options.headers= {
      'Content-Type':'application/json',
      'cookie':cookie
    };
    try {
      // var formData = FormData.fromMap(data!);
      // Response response = await dio.post(url, data: formData,queryParameters: query);

      print('url post : $url');
      Response response = await dio.put(url,queryParameters: query,data: data);

      onSuccess(response);
    }on DioError catch(error){
      onError(ApIError(error.message,error.response));
    }on SocketException catch(error){
      print(error.message.toString());
      onError(ApIError('لا يوجد اتصال بالانترنت :(',null));
    }catch(error){
      onError(ApIError(error.toString(),null));
    }
  }

}

class ApIError{
  String message;
  Response? response;

  ApIError(this.message,this.response);
}


