import 'dart:io';
import 'package:ast/screens/home_screen.dart';
import 'package:ast/shared/ast_cubit/cubit.dart';
import 'package:ast/shared/ast_cubit/states.dart';
import 'package:ast/shared/components/Constants.dart';
import 'package:ast/shared/observer.dart';
import 'package:ast/styles/theme.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async{
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  cameras =await availableCameras();

  // await CacheHelper.init();
  // bool? GroceriesIsBoarding = CacheHelper.getData(key: 'GroceriesOnBoarding');
  //
  // await MyHive.init();
  //
  // if(await Hive.boxExists(MyHive.loginModelKey)){
  //   await MyHive.openBox(
  //     name: MyHive.loginModelKey,
  //   );
  //   LoginModel model= await MyHive.getValue('UserInfo');
  //   token=model.token;
  //   print('finally! $token');
  // }

  // Widget? widget;
  //
  // if(GroceriesIsBoarding != null){
  //   if(token != null)
  //     widget=HomeLayout();
  //   else {
  //     print('token equal null!');
  //     widget = GroceriesLoginScreen();
  //   }
  // }else{
  //   widget = GroceriesOnBoarding();
  // }

  Bloc.observer = MyBlocObserver();
  runApp( MyApp(startWidget: HomeScreen()));

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