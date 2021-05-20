import 'package:flutter/material.dart';
import 'package:my_password_flutter/page/account_list.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      home: new AccountListPage(),
    );
  }
}
