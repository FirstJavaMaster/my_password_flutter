import 'package:flutter/material.dart';

class GradientBar {
  static Widget gradientBar = _getGradientBar();

  static Widget _getGradientBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5151E5), Color(0xFF72EDF2)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
    );
  }
}
