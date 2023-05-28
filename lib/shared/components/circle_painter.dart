import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
    final double x;
  final double y;
  final double radius;

  DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
    required this.x,
    required this.y,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(x,y);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final double circumference = 2 * math.pi * radius;
    final double dashSpace = dashLength + gapLength;
    final int numDashes = (circumference / dashSpace).floor();

    final double anglePerDash = (2 * math.pi) / numDashes;

    for (int i = 0; i < numDashes; i++) {
      final double startAngle = i * anglePerDash;
      final double endAngle = (i + dashLength / dashSpace) * anglePerDash;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        endAngle - startAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(DashedCirclePainter oldDelegate) {
    return color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        dashLength != oldDelegate.dashLength ||
        gapLength != oldDelegate.gapLength;
  }
}
