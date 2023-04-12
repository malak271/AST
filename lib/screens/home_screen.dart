import 'package:ast/screens/add_new_test_screen.dart';
import 'package:ast/shared/ast_cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/ast_cubit/states.dart';
import '../shared/components/components.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateTo(context,NewTest());
        },
        icon: const Icon(Icons.edit),
        label: const Text('New Test'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 150,
        title:Image(
          image: AssetImage('assets/images/background2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<AppCubit, States>(
            builder: (context, state) {
              return itemBuilder(context);
            },
            listener: (context, state) {

            }),
      ),
    );
  }

  Widget itemBuilder(context) => SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: ListView.separated(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context,index)=>buildCardItem(),
                separatorBuilder: (context,index)=>
                    SizedBox(height: 10,),
                itemCount: 20),
          ),
          SizedBox(height: 20,),
        ],
      ),
    ),
  );

  Widget buildCardItem()=>Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30), //border corner radius
      boxShadow:[
        BoxShadow(
          color: Colors.grey.withOpacity(0.1), //color of shadow
          spreadRadius: 5, //spread radius
          blurRadius: 7, // blur radius
          offset: Offset(0, 2), // changes position of shadow
          //first paramerter of offset is left-right
          //second parameter is top to down
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('AST ID: 1',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
          ),
        ),
        Text('klessiblia',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
          ),
        ),
        Text('By: user',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
          ),
        ),
      ],
    ),
  );

}
