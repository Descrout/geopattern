// ignore_for_file: constant_identifier_names

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:geopattern_flutter/patterns/chevrons.dart';
import 'package:geopattern_flutter/patterns/concentric_circles.dart';
import 'package:geopattern_flutter/patterns/diamonds.dart';
import 'package:geopattern_flutter/patterns/hexagons.dart';
import 'package:geopattern_flutter/patterns/nested_squares.dart';
import 'package:geopattern_flutter/patterns/octagons.dart';
import 'package:geopattern_flutter/patterns/overlapping_circles.dart';
import 'package:geopattern_flutter/patterns/overlapping_rings.dart';
import 'package:geopattern_flutter/patterns/pattern.dart' as geo;
import 'package:geopattern_flutter/patterns/plus_signs.dart';
import 'package:geopattern_flutter/patterns/squares.dart';
import 'package:geopattern_flutter/patterns/triangles.dart';
import 'package:geopattern_flutter/helpers.dart';

enum PatternType {
  Hexagons,
  Octagons,
  NestedSquares,
  Triangles,
  Squares,
  PlusSigns,
  ConcentricCircles,
  OverlappingCircles,
  OverlappingRings,
  Diamonds,
  Chevrons,
}

class MistikPattern {
  final PatternType type;

  final Color bgColor;

  final List<Color> fillColors;
  final List<Color> strokeColors;

  final double size;

  final double? strokeWidth;

  MistikPattern({
    required this.type,
    required this.bgColor,
    required this.fillColors,
    required this.strokeColors,
    required this.size,
    this.strokeWidth,
  });

  geo.Pattern toPattern() {
    if (this.fillColors.length != this.strokeColors.length) {
      throw Exception("colors lengths must be same");
    }

    final colorLen = this.fillColors.length;
    final n = sqrt(Helpers.toExactSq(colorLen)).floor();

    final fillColors = List.generate(
      n * n,
      (i) => this.fillColors[i % colorLen],
    );

    final strokeColors = List.generate(
      n * n,
      (i) => this.strokeColors[i % colorLen],
    );

    final strokeColor = strokeColors.first;

    switch (type) {
      case PatternType.Hexagons:
        return Hexagons(
          side: size,
          nx: n,
          ny: n,
          strokeColor: strokeColor,
          fillColors: fillColors,
        );
      case PatternType.Octagons:
        return Octagons(
          side: size,
          nx: n,
          ny: n,
          strokeColor: strokeColor,
          fillColors: fillColors,
        );
      case PatternType.NestedSquares:
        final outerside = size + 10;

        return NestedSquares(
          side: size,
          outerside: outerside,
          nx: n,
          ny: n,
          strokeColors: strokeColors,
        );
      case PatternType.Triangles:
        return Triangles(
          side: size,
          nx: n,
          ny: n,
          fillColors: fillColors,
          strokeColor: strokeColor,
        );
      case PatternType.Squares:
        return Squares(
          side: size,
          nx: n,
          ny: n,
          fillColors: fillColors,
          strokeColor: strokeColor,
        );
      case PatternType.PlusSigns:
        return PlusSigns(
          side: size,
          nx: n,
          ny: n,
          fillColors: fillColors,
          strokeColor: strokeColor,
        );
      case PatternType.OverlappingCircles:
        return OverlappingCircles(
          radius: size,
          nx: n,
          ny: n,
          fillColors: fillColors,
        );
      case PatternType.OverlappingRings:
        return OverlappingRings(
          radius: size,
          strokeWidth: strokeWidth!,
          nx: n,
          ny: n,
          strokeColors: strokeColors,
        );
      case PatternType.Diamonds:
        return Diamonds(
          w: size,
          h: size,
          nx: n,
          ny: n,
          fillColors: fillColors,
          strokeColor: strokeColor,
        );
      case PatternType.ConcentricCircles:
        return ConcentricCircles(
          radius: size,
          strokeWidth: strokeWidth!,
          nx: n,
          ny: n,
          strokeColors: strokeColors,
          fillColors: fillColors,
        );
      default:
        return Chevrons(
          side: size,
          nx: n,
          ny: n,
          fillColors: fillColors,
          strokeColor: strokeColor,
        );
    }
  }

  Future<ui.Image?> toImage(double width, double height) async {
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromPoints(
          const Offset(0.0, 0.0),
          Offset(width, height),
        ),
      );

      final pattern = toPattern();

      canvas.drawColor(bgColor, BlendMode.color);
      for (var i = 0.0; i < height; i += pattern.size.height) {
        for (var j = 0.0; j < width; j += pattern.size.width) {
          pattern.paint(canvas, Offset(j, i));
        }
      }

      final picture = recorder.endRecording();
      return await picture.toImage(width.toInt(), height.toInt());
    } catch (_) {
      return null;
    }
  }
}
