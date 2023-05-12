import 'dart:io';
import 'package:ast/screens/login_screen.dart';
import 'package:ast/shared/ast_cubit/cubit.dart';
import 'package:ast/shared/ast_cubit/states.dart';
import 'package:ast/shared/components/Constants.dart';
import 'package:ast/shared/observer.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'network/local/chache_helper.dart';

void main() async{

  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  HttpOverrides.global = MyHttpOverrides();

  cameras =await availableCameras();
  await CacheHelper.init();
  // cookie=CacheHelper.getData(key:'cookie');
  // bool? isBoarding = CacheHelper.getData(key: 'onBoarding');

  Widget? widget;
  widget=LoginScreen();
  // if(isBoarding != null){
  //   if(cookie != null){
  //     widget=HomeScreen();
  //   }else{
  //     widget=LoginScreen();
  //   }
  // }
  // else{
  //   OnBoarding();
  // }


  Bloc.observer = MyBlocObserver();

  runApp( MyApp(startWidget: widget));
  FlutterNativeSplash.remove();
}


class MyApp extends StatelessWidget {

  final Widget startWidget;

  MyApp({required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context)=> AppCubit(),
        ),
      ],
      child: BlocConsumer<AppCubit,States>(
        listener: (BuildContext context, state) {  },
        builder: (BuildContext context, Object? state) {
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            builder:(context,child)=> MaterialApp(
              // theme: MyLightTheme.getTheme(),
              // darkTheme: darkTheme,
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.light,
              home: startWidget,
            ),
          );
        },
      ),
    );
  }
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}