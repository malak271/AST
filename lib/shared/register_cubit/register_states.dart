abstract class RegisterStates{}

class RegisterInitialState extends RegisterStates{}

class RegisterSuccessState extends RegisterStates{
  final String message;
  RegisterSuccessState(this.message);
}

class RegisterLoadingState extends RegisterStates{}

class RegisterErrorState extends RegisterStates{
  final String error;
  RegisterErrorState(this.error);
}

class RegisterChangePasswordVisibilityState extends RegisterStates{}








