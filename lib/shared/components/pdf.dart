import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../ast_cubit/cubit.dart';
import 'package:image/image.dart' as IMG;

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

PdfBitmap? originalimage;
PdfBitmap? finalimage;
createPdf(AppCubit cubit, context) async {
  final PdfDocument document = PdfDocument();

  PdfPageTemplateElement header = PdfPageTemplateElement(
      Rect.fromLTWH(0, 0, document.pageSettings.size.width, 100));
//Create the date and time field
  PdfDateTimeField dateAndTimeField = PdfDateTimeField(
      font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  dateAndTimeField.date = DateTime.now();
  dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';

//Create the composite field with date field
  PdfCompositeField compositefields = PdfCompositeField(
      font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      text: '{0}      AST Results',
      fields: <PdfAutomaticField>[dateAndTimeField]);

//Add composite field in header
  compositefields.draw(header.graphics,
      Offset(0, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));
  document.template.top = header;

  // if (cubit.image_path != null) {
  //   Size size = ImageSizeGetter.getSize(FileInput(File(cubit.image_path!)));
  //
  //   final File imageFile = File(cubit.image_path!);
  //   final List<int> imageBytes = await imageFile.readAsBytes();
  //
  //   IMG.Image img = IMG.decodeImage(imageBytes)!;
  //   IMG.Image resized = IMG.copyResize(img,
  //       width: (MediaQuery.of(context).size.width).toInt(),
  //       height: (size.height * (MediaQuery.of(context).size.width / size.width))
  //           .toInt());
  //   List<int> resizedData = IMG.encodeJpg(resized);
  //
  //   originalimage = PdfBitmap(resizedData);
  //   var pages=document.pages.add();
  //
  //
  //   pages
  //       .graphics.drawString(
  //     'Original image',
  //     PdfStandardFont(PdfFontFamily.helvetica, 12),
  //   );
  //
  //   pages
  //       .graphics
  //       .drawImage(PdfBitmap(imageBytes),  Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width, size.height*(MediaQuery.of(context).size.width/size.width) ));
  // }

  if (cubit.drawResultImg != null) {
    Size size = ImageSizeGetter.getSize(MemoryInput(cubit.drawResultImg!));

    final PdfBitmap image = PdfBitmap(cubit.drawResultImg!);

    finalimage = image;
    // document.pages
    //     .add()
    //     .graphics
    //     .drawImage(image,  Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width, size.height*(MediaQuery.of(context).size.width/size.width) ));
  }

  final PdfPage page = document.pages.add();
  final PdfGrid grid = PdfGrid();
  grid.columns.add(count: 2);

  PdfGridRow row5 = grid.rows.add();
  row5.cells[0].value = 'Sample type';
  row5.cells[1].value = cubit.sampleType;

  PdfGridRow row6 = grid.rows.add();
  row6.cells[0].value = 'Bacteria';
  row6.cells[1].value = cubit.bacteria;

  for (int i = 0; i < cubit.images_info.length; i++) {
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = cubit.images_info[i].label;
    row.cells[1].value = cubit.images_info[i].result;
  }


  PdfGridRow row3 = grid.rows.add();
  row3.cells[0].columnSpan = 2;
  row3.cells[0].imagePosition = PdfGridImagePosition.stretch;
  row3.cells[0].value = finalimage;

  grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
  grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 0, page.getClientSize().width, page.getClientSize().height));

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
      textColor: Colors.white,
    );
  } catch (error) {
    print('Error saving file: $error');
  }
}
