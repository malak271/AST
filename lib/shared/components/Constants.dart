import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var  cameras;

String UPLOAD= "http://localhost:8000/api/upload";

String? token;

BoxDecoration DECORATION=BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0, 3), // changes position of shadow
    ),
  ],
);

SizedBox SIZEDBOX20=SizedBox(height: 20,);

void printFullText(String text){
  final pattern =RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match)=>print(match.group(0)));
}