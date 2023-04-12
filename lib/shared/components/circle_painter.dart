import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final double x;
  final double y;
  final double radius;

  CirclePainter({
    required this.x,
    required this.y,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(x, y), // center of the circle
      radius, // radius of the circle
      paint,
    );
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return true;
  }
}