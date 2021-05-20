import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  int currentId = 0;

  AccountPage(this.currentId);

  @override
  State<StatefulWidget> createState() {
    return new AccountState(currentId);
  }
}

class AccountState extends State<AccountPage> {
  int currentId = 0;
  bool isCreate = true;

  AccountState(int currentId) {
    this.currentId = currentId;
    this.isCreate = currentId == 0;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(isCreate ? '创建账号' : '账号详情'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('返回上一页'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
