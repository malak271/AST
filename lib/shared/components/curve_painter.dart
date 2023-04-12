import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color =HexColor('40A76A');
    paint.style = PaintingStyle.fill;

    var path = Path();

    // path.moveTo(size.width , size.height );
    // path.quadraticBezierTo(size.width * 0.9, size.height * 0.875,
    //     size.width * 0.5, size.height * 0.9167);
    // path.quadraticBezierTo(size.width * 0.75, size.height * 0.9584,
    //     size.width * 1.0, size.height * 0.9167);
    path.lineTo(size.width , size.height *.25);
    path.lineTo( size.height,size.width);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


