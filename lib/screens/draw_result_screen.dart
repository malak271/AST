
import 'package:ast/screens/test_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../shared/ast_cubit/cubit.dart';
import '../shared/ast_cubit/states.dart';
import '../shared/components/components.dart';

class DrawResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.getCubit(context);
    return BlocConsumer<AppCubit, States>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Result'),
              backgroundColor: HexColor('40A76A'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state is DrawImageLoadingState)
                      const CircularProgressIndicator(),
                    if (cubit.drawResultImg!=null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.memory(
                          cubit.drawResultImg!,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: DefaultButton(
                        function: () {
                          Navigator.pop(context);
                        },
                        text: 'BACK'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DefaultButton(
                        function: () {
                          if(!cubit.resultReady)
                             cubit.sendResults();
                          navigateTo(context, TestResultScreen());
                        },
                        text: 'NEXT'),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
