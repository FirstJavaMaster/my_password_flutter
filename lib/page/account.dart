import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/page/account_relation_list.dart';

class AccountPage extends StatefulWidget {
  int id = 0;

  AccountPage(this.id);

  @override
  State<StatefulWidget> createState() {
    return new AccountState(id);
  }
}

class AccountState extends State<AccountPage> {
  int id = 0;
  bool isCreate = true;
  Account account = Account.ofEmpty();

  // 表单key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 构造方法
  AccountState(int id) {
    this.id = id;
    this.isCreate = id == 0;

    DatabaseUtils.getDatabase().then((db) {
      db.accountDao.findById(this.id).then((account) {
        print('查询ID: $id  --> $account');
        setState(() {
          this.account = account ?? Account.ofEmpty();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isCreate ? '创建账号' : '账号详情'),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                '基本信息',
                textScaleFactor: 1.5,
              )),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: '网站名称'),
                    controller: TextEditingController(text: this.account.site_name),
                    onChanged: (value) => {this.account.site_name = value},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入网站名称';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: '用户名'),
                    controller: TextEditingController(text: this.account.user_name),
                    onChanged: (value) => {this.account.user_name = value},
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: '密码'),
                    controller: TextEditingController(text: this.account.password),
                    onChanged: (value) => {this.account.password = value},
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: '其他备注'),
                    controller: TextEditingController(text: this.account.memo),
                    onChanged: (value) => {this.account.memo = value},
                    minLines: 4,
                    maxLines: 8,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      }
                      if (value.length > 200) {
                        return '内容长度不可超过200';
                      }
                      return null;
                    },
                  ),
                ],
              )),
          Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                '关联账号',
                textScaleFactor: 1.5,
              )),
          AccountRelationList(id),
          Row(
            children: [
              ElevatedButton(
                child: Text('校 验'),
                onPressed: () {
                  var validateResult = _formKey.currentState!.validate();
                  Fluttertoast.showToast(msg: validateResult ? '校验成功' : '校验失败');
                },
              ),
              ElevatedButton(
                child: Text('保 存'),
                onPressed: () {
                  bool validateResult = _formKey.currentState!.validate();
                  if (!validateResult) {
                    return;
                  }
                  DatabaseUtils.getDatabase().then((db) {
                    account.update_time = DateTime.now().toString();
                    db.accountDao.add(account);
                    Fluttertoast.showToast(msg: '保存成功');
                  });
                },
              ),
              ElevatedButton(
                child: Text('+ +'),
                onPressed: () {
                  var account = Account(null, getRandomWords(), getRandomWords(), getRandomWords(), getRandomWords(), getRandomWords(),
                      DateTime.now().toString(), DateTime.now().toString(), getRandomWords());
                  DatabaseUtils.getDatabase().then((db) {
                    db.accountDao.add(account).then((id) {
                      Navigator.of(context).pop(true);
                    });
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                child: Text('<- 返回'),
                onPressed: () {
                  Navigator.pop(context, '123');
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  String getRandomWords() {
    return new WordPair.random().first;
  }
}
