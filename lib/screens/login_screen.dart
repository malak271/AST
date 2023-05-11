import 'package:ast/screens/register_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../shared/components/components.dart';
import '../shared/login_cubit/login_cubit.dart';
import '../shared/login_cubit/login_states.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => LoginCubit(),),
      ],
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            Fluttertoast.showToast(
              msg: state.error,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
          if (state is LoginSuccessState) {
            navigateAndFinish(context, HomeScreen());
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: HexColor("ede3ca"),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image(
                            image: AssetImage('assets/images/logo.jpeg'),
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          DefaultTextFormField(
                            controller: userNameController,
                            type: TextInputType.text,
                            validator: (String? value) {
                              if ((value ?? '').isEmpty) {
                                return 'username must not be empty';
                              }
                            },
                            text: 'user name',
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          DefaultTextFormField(
                            controller: passwordController,
                            type: TextInputType.text,
                            isPassword: true,
                            validator: (String? value) {
                              if ((value ?? '').isEmpty) {
                                return 'password must not be empty';
                              }
                            },
                            text: 'password',
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          SizedBox(height: 5.h),
                          ConditionalBuilder(
                              condition: state is! LoginLoadingState,
                              builder: (context) =>
                                  DefaultButton(
                                      function: () {
                                        if (formKey.currentState!.validate()) {
                                          LoginCubit.get(context).login(
                                              username: userNameController.text,
                                              password: passwordController
                                                  .text);
                                        }
                                      },
                                      text: 'login'),
                              fallback: (context) =>
                                  Center(child: CircularProgressIndicator())),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have an account?'),
                              TextButton(
                                  onPressed: () {
                                    navigateTo(context, RegisterScreen());
                                  }, child: Text('Sign up')),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }}


