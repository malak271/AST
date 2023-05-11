
abstract class LoginStates{}
class LoginInitialState extends LoginStates{}

class LoginSuccessState extends LoginStates{
  final cookie;
  LoginSuccessState(this.cookie);
}

class LoginLoadingState extends LoginStates{}

class LoginErrorState extends LoginStates{
  final String error;
  LoginErrorState(this.error);
}