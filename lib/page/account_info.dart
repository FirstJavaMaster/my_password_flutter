import 'dart:async';
import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/page/account.dart';

class AccountInfo extends StatefulWidget {
  int id;

  AccountInfo(this.id);

  @override
  State<StatefulWidget> createState() {
    return AccountInfoState(id);
  }
}

class AccountInfoState extends State<AccountInfo> {
  // 当前id
  int id;

  // 当前 account
  Account account = Account.ofEmpty();

  // 是否数据已经被更新. 决定了"保存"按钮的状态
  final StreamController<bool> _dataChangedSC = StreamController();

  // 表单key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 构造方法
  AccountInfoState(this.id);

  @override
  void initState() {
    super.initState();
    DatabaseUtils.getDatabase().then((db) {
      db.accountDao.findById(this.id).then((account) {
        setState(() {
          this.account = account ?? Account.ofEmpty();
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dataChangedSC.close();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: _buildForm(),
            ),
          ),
          StreamBuilder<bool>(
            stream: _dataChangedSC.stream,
            initialData: false,
            builder: (context, snapshot) {
              return _buildButton(ElevatedButton(
                child: Text('保 存'),
                onPressed: (snapshot.data ?? false)
                    ? () {
                        bool validateResult = _formKey.currentState!.validate();
                        if (!validateResult) {
                          return;
                        }
                        DatabaseUtils.getDatabase().then((db) {
                          account.site_pin_yin_name = PinyinHelper.getPinyinE(account.site_name);
                          account.update_time = DateTime.now().toString();
                          db.accountDao.add(account).then((id) {
                            this.id = id;
                            this.account.id = id;
                            _dataChangedSC.sink.add(false);
                            Fluttertoast.showToast(msg: '保存成功');
                          });
                        });
                      }
                    : null,
              ));
            },
          ),
          _buildButton(
            ElevatedButton(
              child: Text('+ +'),
              onPressed: () {
                var account = Account(null, getRandomWords(), getRandomWords(), getRandomWords(), getRandomWords(), getRandomWords(), DateTime.now().toString(),
                    DateTime.now().toString(), getRandomWords());
                DatabaseUtils.getDatabase().then((db) {
                  db.accountDao.add(account).then((id) {
                    Navigator.of(context).pop(true);
                  });
                });
              },
            ),
          ),
          _buildButton(
            ElevatedButton(
              child: Text('change'),
              onPressed: () {
                IdChangeNotification(Random().nextInt(100)).dispatch(context);
              },
            ),
          ),
          _buildButton(
            OutlinedButton(
              child: Text('删 除'),
              style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: id == 0 ? null : () => _deleteAccount(),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: '网站名称', border: OutlineInputBorder()),
              controller: TextEditingController(text: this.account.site_name),
              onChanged: (value) {
                if (account.site_name == value) {
                  return;
                }
                account.site_name = value;
                _dataChangedSC.sink.add(true);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入网站名称';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: '用户名', border: OutlineInputBorder()),
              controller: TextEditingController(text: this.account.user_name),
              onChanged: (value) {
                if (account.user_name == value) {
                  return;
                }
                account.user_name = value;
                _dataChangedSC.sink.add(true);
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: '密码', border: OutlineInputBorder()),
              controller: TextEditingController(text: this.account.password),
              onChanged: (value) {
                if (account.password == value) {
                  return;
                }
                account.password = value;
                _dataChangedSC.sink.add(true);
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: '其他备注', border: OutlineInputBorder()),
              controller: TextEditingController(text: this.account.memo),
              onChanged: (value) {
                if (account.memo == value) {
                  return;
                }
                account.memo = value;
                _dataChangedSC.sink.add(true);
              },
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
        ));
  }

  String getRandomWords() {
    return new WordPair.random().first;
  }

  _buildButton(Widget btnWidget) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [Expanded(child: btnWidget)],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('确定要删除当前账号吗?'),
          actions: [
            TextButton(
              child: Text('取消'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('删除', style: TextStyle(color: Colors.red)),
              onPressed: () {
                DatabaseUtils.getDatabase().then((db) {
                  db.accountRelationDao.deleteByAccountId(id);
                  db.accountDao.deleteByEntity(account).then((value) {
                    Fluttertoast.showToast(msg: '删除成功');
                    Navigator.of(context).pop(true);
                  });
                });
              },
            ),
          ],
        );
      },
    ).then((value) => value ? Navigator.of(context).pop(true) : null);
  }
}
