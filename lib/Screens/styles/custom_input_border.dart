
import 'package:flutter/material.dart';

class CustomInputBorder extends InputBorder {

  const CustomInputBorder({borderSide = BorderSide.none});

  @override
  InputBorder copyWith({BorderSide borderSide}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => throw UnimplementedError();

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    // TODO: implement getInnerPath
    throw UnimplementedError();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    // TODO: implement getOuterPath
    throw UnimplementedError();
  }

  @override
  // TODO: implement isOutline
  bool get isOutline => throw UnimplementedError();

  @override
  void paint(Canvas canvas, Rect rect,
      {double gapStart, double gapExtent = 0.0, double gapPercentage = 0.0, TextDirection textDirection}) {
    // TODO: implement paint
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    throw UnimplementedError();
  }
}