import 'package:ast/shared/register_cubit/register_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void register ({
    required String username,
    required String email,
    required String password,
  }) async{
    emit(RegisterLoadingState());
    DioHelper.postData(
        url: 'auth/signup',
        data: {
          'email':'$email',
          'username':'$username',
          'password':'$password',
        },
        onError: (ApIError) {
          print(ApIError.message.toString());
          emit(RegisterErrorState(ApIError.message));
        },
        onSuccess: (response) {
          if(response.data['Status']=="Failure")
            emit(RegisterErrorState(response.data['Message']));
          emit(RegisterSuccessState(response.data['Message']));
        });
  }

}
