import 'package:flutter/material.dart';

class Motion {
  static const duration = Duration(milliseconds: 220);

  static Widget fadeSlide({
    required Widget child,
    bool visible = true,
  }) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: duration,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, 0.02),
        duration: duration,
        child: child,
      ),
    );
  }
}
