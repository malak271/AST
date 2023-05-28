import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

// ThemeData darkTheme = ThemeData(
//     textTheme: const TextTheme(
//         bodyText1: TextStyle(
//             fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
//     scaffoldBackgroundColor: HexColor('FAFAFA'),
//     primarySwatch: buildMaterialColor(HexColor('40A76A')),
//     appBarTheme:  AppBarTheme(
//       systemOverlayStyle: SystemUiOverlayStyle(
//         statusBarColor:buildMaterialColor(HexColor('FAFAFA')),
//         statusBarIconBrightness: Brightness.light,
//       ),
//       backgroundColor: HexColor('FAFAFA'),
//       titleSpacing: 20,
//       elevation: 0.0,
//       titleTextStyle: TextStyle(
//         color: Colors.white,
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//       iconTheme: IconThemeData(
//         color: HexColor('40A76A'),
//       ),
//     ),
//     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//         type: BottomNavigationBarType.fixed,
//         // selectedItemColor: Colors.deepOrange,
//         elevation: 20));

class MyLightTheme{
  static ThemeData getTheme(){
    return ThemeData(
        buttonTheme: MyButtonTheme.getButtonTheme(),
        textTheme: MyTextTheme.getTextTheme() ,
        scaffoldBackgroundColor: HexColor('FAFAFA'),
        primarySwatch:buildMaterialColor(MyColor.getColor()) ,
        appBarTheme:  MyAppBarTheme.getAppBarTheme(),
        bottomNavigationBarTheme:MyBottomNavigationBarTheme.getBottomNavigationBarTheme() );
  }
}

class MyButtonTheme{
  static ButtonThemeData getButtonTheme(){
    return ButtonThemeData(
      buttonColor:MyColor.getColor(),
    );
   }
}

class MyTextTheme{
  static TextTheme getTextTheme(){
    return TextTheme(
        bodyText1: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: HexColor('333333')));
  }
}

class MyAppBarTheme{
  static AppBarTheme getAppBarTheme(){
    return AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor:buildMaterialColor(MyColor.getBackGroundColor()),
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor:MyColor.getBackGroundColor(),
      titleTextStyle: TextStyle(color: Colors.green),
      titleSpacing: 15,
      elevation: 0.0,
      iconTheme: IconThemeData(
        color:MyColor.getColor(),
      ),
    );
  }
}

class MyBottomNavigationBarTheme{
  static BottomNavigationBarThemeData  getBottomNavigationBarTheme(){
    return BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: MyColor.getColor(),
        elevation: 20);
  }
}

class MyColor{
  static getColor(){
    return HexColor('40A76A');
  }
  static getBackGroundColor(){
    return Colors.white;
  }
}

// ThemeData lightTheme = ThemeData(
//     buttonTheme: ButtonThemeData(
//       buttonColor: HexColor('40A76A'),
//     ),
//     textTheme:  TextTheme(
//         bodyText1: TextStyle(
//             fontSize: 16, fontWeight: FontWeight.w500, color: HexColor('333333'))),
//     scaffoldBackgroundColor: HexColor('FAFAFA'),
//     primarySwatch: buildMaterialColor(HexColor('40A76A')),
//     appBarTheme:  AppBarTheme(
//       systemOverlayStyle: SystemUiOverlayStyle(
//         statusBarColor:buildMaterialColor(HexColor('FAFAFA')),
//         statusBarIconBrightness: Brightness.dark,
//       ),
//       backgroundColor: HexColor('FAFAFA'),
//       titleSpacing: 15,
//       elevation: 0.0,
//       iconTheme: IconThemeData(
//         color: HexColor('40A76A'),
//       ),
//     ),
//     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//         type: BottomNavigationBarType.fixed,
// // selectedItemColor: Colors.deepOrange,
//         elevation: 20));

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
