import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/entity/account.dart';

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
            var account = new Account(
                null,
                getRandomWords(),
                getRandomWords(),
                getRandomWords(),
                getRandomWords(),
                getRandomWords(),
                getRandomWords(),
                getRandomWords(),
                getRandomWords());
            DatabaseUtils.getDatabase().then((db) {
              db.accountDao.add(account).then((id) {
                print("自动生成的id: " + id.toString());
                Navigator.of(context).pop();
              });
            });
          },
        ),
      ),
    );
  }

  String getRandomWords() {
    return new WordPair.random().first;
  }
}
