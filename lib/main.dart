import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_password_flutter/page/account/account_list.dart';

void main() {
  runApp(new MyApp());

  // 沉浸式状态栏
  if (Platform.isAndroid) {
    var systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'my_password',
      home: new AccountListPage(),
    );
  }
}
