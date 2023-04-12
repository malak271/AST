import 'dart:io';
import 'dart:typed_data';

import 'package:ast/models/ast_model.dart';
import 'package:flutter/material.dart';

abstract class States {}

class InitialState extends States {}

class UploadImgLoadingState extends States{
  // final List<ASTModel> astModel;
  final String imagePath;
  UploadImgLoadingState(this.imagePath);
}

class UploadImgSuccessState extends States{
  final ASTModel astModel;
  final String imagePath;
  UploadImgSuccessState(this.astModel,this.imagePath);
}

class UploadImgErrorState extends States{ //state 2
  final error;
  UploadImgErrorState(this.error);
}

class ChangePageViewIndexState extends States{}

class GetImgLoadingState extends States{
  // final List<ASTModel> astModel;
  // final String imagePath;
  // UploadImgLoadingState(this.astModel,this.imagePath);
}

class GetImgSuccessState extends States{
  final Uint8List croppedImg;
  GetImgSuccessState(this.croppedImg);
}

class GetImgErrorState extends States{ //state 2
  final error;
  GetImgErrorState(this.error);
}
