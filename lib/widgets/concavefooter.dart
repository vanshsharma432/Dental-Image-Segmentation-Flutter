import 'package:flutter/material.dart';
import '../constants/theme.dart';

class ConcavePainter extends CustomPainter {
  final Color color;
  ConcavePainter({Color? color}) : color = color ?? AppTheme.lightTheme.colorScheme.secondary;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();

    // 1. Start at the top left corner
    path.moveTo(0, 0);

    // 2. Create the concave top edge
    // quadraticBezierTo(controlX, controlY, endX, endY)
    // We put the control point at center-width, but 40 pixels DOWN
    path.quadraticBezierTo(size.width / 2, 160, size.width, 80);

    // 3. Draw the rest of the rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
