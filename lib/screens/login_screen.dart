import 'package:ast/screens/register_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../shared/components/components.dart';
import '../shared/login_cubit/login_cubit.dart';
import '../shared/login_cubit/login_states.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
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
            backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                              'assets/images/logo700.png',
                            fit: BoxFit.cover,
                            width: 230,
                            height: 230,
                          ),
                          SizedBox(height: 10,),
                          DefaultTextFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validator: (String? value) {
                              if ((value ?? '').isEmpty) {
                                return 'email must not be empty';
                              }
                            },
                            text: 'email',
                            prefix: Icons.email
                          ),
                          mySizedBox,
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
                              prefix: Icons.lock
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
                                              email: emailController.text,
                                              password: passwordController
                                                  .text);
                                        }
                                      },
                                      text: 'login'),
                              fallback: (context) =>
                                  Center(child: CircularProgressIndicator())),
                          mySizedBox,
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


