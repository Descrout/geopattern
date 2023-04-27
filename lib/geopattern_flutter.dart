library geopattern_flutter;

import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:geopattern_flutter/mistik_pattern.dart';
import 'patterns/pattern.dart';

class PatternPainter extends CustomPainter {
  Color background;
  Pattern pattern;

  PatternPainter({required this.pattern, required this.background});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(background, BlendMode.color);
    for (var i = 0.0; i < size.height; i += pattern.size.height) {
      for (var j = 0.0; j < size.width; j += pattern.size.width) {
        pattern.paint(canvas, Offset(j, i));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ImagePainter extends CustomPainter {
  ImagePainter({
    required this.image,
  });

  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MistikPainter extends CustomPainter {
  final MistikPattern pattern;
  final Pattern _pattern;

  MistikPainter({required this.pattern}) : _pattern = pattern.toPattern();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(pattern.bgColor, BlendMode.src);
    for (var i = 0.0; i < size.height; i += _pattern.size.height) {
      for (var j = 0.0; j < size.width; j += _pattern.size.width) {
        _pattern.paint(canvas, Offset(j, i));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
