import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../shared/components/components.dart';
import '../shared/register_cubit/register_cubit.dart';
import '../shared/register_cubit/register_states.dart';
import 'login_screen.dart';


class RegisterScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => RegisterCubit(),),
      ],
      child: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) async {
        if (state is RegisterSuccessState) {
          Fluttertoast.showToast(
            msg: 'account created successfully',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            fontSize: 16,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          navigateAndFinish(context, LoginScreen());
        } else if (state is RegisterErrorState) {
          Fluttertoast.showToast(
            msg: state.error,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            fontSize: 16,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }

      }, builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Register'),
            backgroundColor: HexColor('40A76A'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Create your account',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DefaultTextFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      validator: (String? value) {
                        if ((value ?? '').isEmpty) {
                          return 'email must not be empty';
                        }
                      },
                      text: 'email',
                    ),
                    SizedBox(
                      height: 20,
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
                      height: 20,
                    ),
                    DefaultTextFormField(
                      controller: passwordController,
                      type: TextInputType.text,
                      validator: (String? value) {
                        if ((value ?? '').isEmpty) {
                          return 'password must not be empty';
                        }
                      },
                      text: 'password',
                      isPassword:true
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ConditionalBuilder(
                        condition: state is! RegisterLoadingState,
                        builder: (context) => DefaultButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                               RegisterCubit.get(context).register(
                                  email: emailController.text,
                                  username: userNameController.text,
                                  password: passwordController.text,
                               );

                            }
                          },
                          text: 'Register',
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator())),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}