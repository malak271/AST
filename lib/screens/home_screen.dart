import 'package:ast/screens/add_new_test_screen.dart';
import 'package:ast/shared/ast_cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../models/user_tests_model.dart';
import '../shared/ast_cubit/states.dart';
import '../shared/components/components.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var cubit=AppCubit.getCubit(context);
    cubit.getUserTests();
    return Scaffold(
        backgroundColor: HexColor("ede3ca"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateTo(context,NewTest());
        },
        icon: const Icon(Icons.edit),
        label: const Text('New Test'),
        backgroundColor: HexColor('40A76A'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        backgroundColor: HexColor('40A76A'),
        titleSpacing: 0,
        title: Text('My Tests:'),
        leading: Icon(Icons.arrow_back_ios_outlined),
      ),
      body: BlocConsumer<AppCubit, States>(
        listener: (context,state)=>{},
        builder: (context,state) {
          // var cubit = AppCubit.getCubit(context);
          return ConditionalBuilder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: itemBuilder(context,cubit),
              );
            },
            condition: state is GetTestsSuccessState,
            fallback: (BuildContext context) =>Center(child: CircularProgressIndicator()),

          );
        }

        ,
      )
    );
  }

  Widget itemBuilder(context,AppCubit cubit) => SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context,index)=>buildCardItem(cubit.userTests!.data![index]),
              separatorBuilder: (context,index)=>
                  SizedBox(height: 10,),
              itemCount: cubit.userTests!.testsCount??0),
          SizedBox(height: 20,),
        ],
      ),
    ),
  );

  Widget buildCardItem(Data test)=>GestureDetector (
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow:[
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sample type: ${test.sampleType}',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
            ),
          ),
          Text('Bacteria: ${test.bacteria}',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
            ),
          ),
          Text('Created at: ${test.createdAt}',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
            ),
          ),
        ],
      ),
    ),
    onTap: (){
      //open result page
    },
  );

}
