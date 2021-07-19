import 'dart:async';

import 'package:flutter/material.dart';

class DynamicEllipsis extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DynamicEllipsisState();
  }
}

class DynamicEllipsisState extends State<DynamicEllipsis> {
  final String ellipsis = '·';
  int repeatNum = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      this.timer = timer;
      setState(() {
        if (this.repeatNum == 3) {
          this.repeatNum = 0;
        } else {
          this.repeatNum = this.repeatNum + 1;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    this.timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      this.ellipsis * this.repeatNum,
      textScaleFactor: 2,
    );
  }
}
