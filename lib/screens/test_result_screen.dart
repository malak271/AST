import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../shared/ast_cubit/cubit.dart';
import '../shared/ast_cubit/states.dart';
import 'package:permission_handler/permission_handler.dart';


class TestResultScreen extends StatelessWidget {
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
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state is SendAdjLoadingState)
                      CircularProgressIndicator(),
                    if (state is! SendAdjLoadingState)
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              'Antibiotic tested',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            width: double.infinity,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) =>
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(cubit.labels[index]),
                                        Spacer(),
                                        Text(cubit.interprateResults(
                                            cubit.images_info[index].imgId!))
                                      ],
                                    ),
                                  ),
                              itemCount: cubit.images_info.length),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: HexColor('40A76A'),
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {
                                      requestPermissions(cubit, context);
                                    },
                                    child: Text(
                                      "EXPORT AS PDF",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: HexColor('40A76A'),
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "BACK",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  createPdf(AppCubit cubit, context) async {
    final PdfDocument document = PdfDocument();

    final PdfGrid grid = PdfGrid();

    final Uint8List imageData = File(cubit.image_path!).readAsBytesSync();
    final PdfBitmap image = PdfBitmap(imageData);

    document.pages
        .add()
        .graphics
        .drawImage(image,  Rect.fromLTWH(0, 0, 480, 370));

    final PdfPage page = document.pages.add();
    grid.columns.add(count: 2);
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Antibiotic';
    headerRow.cells[1].value = 'Result';
    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    for (int i = 0; i < cubit.images_info.length; i++) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = cubit.labels[i];
      row.cells[1].value = 'S';
    }

    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 0, page
            .getClientSize()
            .width, page
            .getClientSize()
            .height));


    try {
      final output = await getExternalStorageDirectory();
      String filename = DateTime.now().toString();
      final file = File('${output!.path}/$filename.pdf');
      await file.writeAsBytes(await document.save());
      document.dispose();
      Fluttertoast.showToast(
        msg: "PDF saved successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16,
        backgroundColor: Colors.green,
        textColor: Colors.white,);
    } catch (error) {
      print('Error saving file: $error');
    }
  }

  requestPermissions(cubit, context) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      print("j");
      createPdf(cubit, context);
      // Permission granted, you can write PDF files to the device
    } else {
      // Permission denied, show an error message
    }
  }

}
