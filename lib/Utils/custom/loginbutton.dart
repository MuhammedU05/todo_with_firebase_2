import 'package:flutter/material.dart';

class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Replace this with your custom drawing logic for the Google logo
    final Paint paint = Paint()
      ..color = Colors.blue
      // ..color = Colors.black
      // ..style =PaintingStyle.stroke
      
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      // ..moveTo(0, 0)..addArc(Rect.fromCircle(center: Offset(02, 20), radius: 10), 20, 120)
      // // ..arcToPoint()
      // ..lineTo(size.width, 0)
      // ..lineTo(size.width, size.height)
      // ..lineTo(0, size.height)
      // ..close();
      ..moveTo(size.width/2, size.height/2)..relativeLineTo(68.7, 0)
      // ..lineTo(0, 50)
      ..addArc(
          Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: 120, height: 120), 0, 5.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
