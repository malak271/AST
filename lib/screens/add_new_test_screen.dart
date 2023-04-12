import 'package:ast/screens/taking_picture_screen.dart' hide cameras;
import 'package:ast/shared/components/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/ast_cubit/cubit.dart';
import '../shared/ast_cubit/states.dart';
import '../shared/components/components.dart';
import 'package:image_picker/image_picker.dart';

import 'display_picture_screen.dart';

class NewTest extends StatelessWidget {


  var formKey = GlobalKey<FormState>();
  var idController = TextEditingController();
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, States>(
        listener: (context, state) async {
      if(state is UploadImgLoadingState){
        print("========================================");
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {

              // AppCubit.getCubit(context).getCroppedImage(
              //     img_name: state.astModel.cropsDetails![0].imgName!,
              //     img_path: state.astModel.cropsDetails![0].imgFolder!);

              return DisplayPictureScreen(
              // Pass the automatically generated path to
              // the DisplayPictureScreen widget.
                imagePath: state.imagePath,
              //   astModel:state.astModel
            )
              ;
            }
          ),
        );
      }
    },
    builder:(context,state)=>Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async{
                final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                if(pickedFile!=null)
                AppCubit.getCubit(context).uploadImage(imagePath: pickedFile.path);
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Text("IMPORT"),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                navigateTo(context, TakePictureScreen(camera: cameras.first ,));
              },
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text("NEXT")),
            ),
          ],
        ),
      ),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'New Test',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DefaultTextFormField(
                    controller: idController,
                    type: TextInputType.text,
                    validator: (String? value) {
                      if ((value ?? '').isEmpty) {
                        return 'id must not be empty';
                      }
                    },
                    text: 'AST ID',
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {},
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {},
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
