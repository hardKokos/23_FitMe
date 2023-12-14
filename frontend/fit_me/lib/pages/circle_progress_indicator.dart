import 'package:flutter/material.dart';
import 'dart:math';

class CircleProgressIndicator extends CustomPainter {
  final _strokeWidth = 13.0;
  int _currentProgress;
  int _currentGoal;

  CircleProgressIndicator(this._currentProgress, this._currentGoal);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circle = Paint()
        ..strokeWidth = _strokeWidth
        ..color = Colors.blueGrey
        ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = 125;
    canvas.drawCircle(center, radius, circle);

    Paint animationArc = Paint()
    ..strokeWidth = _strokeWidth
    ..color = Colors.blueAccent
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

    double angle = 2 * pi * (_currentProgress / _currentGoal);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        pi / 2, angle, false, animationArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}