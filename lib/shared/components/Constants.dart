import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var  cameras;

const LOGIN='auth/login';

const SIGNUP='auth/signup';

const USER_TESTS='user/tests';

const CREATE_TEST='test/create';

const PROCESS_CROP='process/crops';

const FETCH_CROP='fetch/crop';

const FETCH_DRAW='fetch/draw';

const TEST_CONFIRM='test/confirmation';

String? cookie;

BoxDecoration CARD_DECORATION=BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.1),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0, 2),
    ),
  ],
);

InputDecoration dropdownButtonDecoration=const InputDecoration(
border: OutlineInputBorder(
borderSide: BorderSide(color: Colors.green,width: 1)
),
contentPadding: EdgeInsets.all(4),
focusedBorder:  OutlineInputBorder(
borderSide: BorderSide(color: Colors.green,width: 1)
),
);

