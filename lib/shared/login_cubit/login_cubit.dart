
import 'package:ast/shared/components/Constants.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../network/local/chache_helper.dart';
import '../../network/remote/dio_helper.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  // String? cookie;

  void login({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    DioHelper.postData(
        url: 'auth/login',
        data: {
          'email': '$email',
          'password': '$password',
        },
        onError: (ApIError) {
          print(ApIError.message);
          emit(LoginErrorState(ApIError.message));
        },
        onSuccess: (response) async {

          if( response.headers.value('Set-Cookie') != null) {
            String headerValue = response.headers.value('Set-Cookie')!;
            cookie = headerValue.substring(0, headerValue.indexOf(';'));
            await CacheHelper.saveData(key: 'cookie', value: cookie);
            emit(LoginSuccessState(cookie));
          }else{
            emit(LoginErrorState(response.data['Message']));
          }
        });
  }


}


