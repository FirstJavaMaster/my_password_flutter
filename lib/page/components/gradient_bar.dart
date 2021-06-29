import 'package:flutter/material.dart';

class GradientBar {
  static Widget gradientBar = _getGradientBar();

  static Widget _getGradientBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlue, Colors.cyanAccent.shade400],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
    );
  }
}
