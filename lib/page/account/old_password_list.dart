import 'package:flutter/material.dart';

class OldPasswordList extends StatefulWidget {
  int id;

  OldPasswordList(this.id);

  @override
  State<StatefulWidget> createState() {
    return OldPasswordState(id);
  }
}

class OldPasswordState extends State<OldPasswordList> {
  int id;

  OldPasswordState(this.id);

  @override
  Widget build(BuildContext context) {
    return this.id == 0
        ? Center(child: Text('< < 请先保存基本信息'))
        : Text(
            id.toString(),
            textScaleFactor: 5,
          );
  }
}
