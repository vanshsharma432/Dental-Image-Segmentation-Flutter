import 'package:flutter/material.dart';
import '../constants/theme.dart';

class WavyFooterPainter extends CustomPainter {
  final Color color;
  WavyFooterPainter({Color? color}) : color = color ?? AppTheme.lightTheme.colorScheme.primary;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();

    // Start at the bottom left
    path.lineTo(0, size.height);
    // Draw to the bottom right
    path.lineTo(size.width, size.height);
    // Draw up to the start of the wave (top right)
    path.lineTo(size.width, size.height * 0.1);

    // First curve (Control point is mid-way, pull point is at the top)
    var firstControlPoint = Offset(size.width * 0.75, 0);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.3);
    
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Second curve (Mirroring the first one down)
    var secondControlPoint = Offset(size.width * 0.25, size.height * 0.6);
    var secondEndPoint = Offset(0, size.height * 0.3);

    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}