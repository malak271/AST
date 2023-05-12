

abstract class States {}

class InitialState extends States {}

class GetTestsLoadingState extends States{}

class GetTestsSuccessState extends States{}

class GetTestsErrorState extends States{ //state 2
  final error;
  GetTestsErrorState(this.error);
}

class CreateTestLoadingState extends States{}

class CreateTestSuccessState extends States{}

class CreateTestErrorState extends States{ //state 2
  final error;
  CreateTestErrorState(this.error);
}

class CropImageLoadingState extends States{}

class CropImageSuccessState extends States{}

class CropImageErrorState extends States{ //state 2
  final error;
  CropImageErrorState(this.error);
}

class GetImgLoadingState extends States{}

class GetImgSuccessState extends States{}

class GetImgErrorState extends States{ //state 2
  final error;
  GetImgErrorState(this.error);
}

class NextState extends States{
  final int index;
  NextState(this.index);
}

class SendAdjLoadingState extends States{}

class SendAdjSuccessState extends States{}

class SendAdjErrorState extends States{ //state 2
  final error;
  SendAdjErrorState(this.error);
}

class NoAdjChangedState extends States{}

class ChangePageViewIndexState extends States{}

class DrawImageLoadingState extends States{}

class DrawImageSuccessState extends States{}

class DrawImageErrorState extends States{ 
  final error;
  DrawImageErrorState(this.error);
}