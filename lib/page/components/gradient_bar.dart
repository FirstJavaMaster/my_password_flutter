import 'package:flutter/material.dart';

/// 沉浸式状态栏
class GradientBar {
  static Widget gradientBar = _getGradientBar();

  static Widget _getGradientBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4C83FF), Color(0xFF00EAFF)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
    );
  }
}
