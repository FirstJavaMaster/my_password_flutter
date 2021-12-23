import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/entity/old_password.dart';
import 'package:my_password_flutter/page/account/account.dart';

class BaseInfo extends StatefulWidget {
  int id;

  BaseInfo(this.id);

  @override
  State<StatefulWidget> createState() {
    return BaseInfoState(id);
  }
}

class BaseInfoState extends State<BaseInfo> {
  // 当前id
  int id;

  // 当前 account
  Account account = Account.ofEmpty();

  // 是否数据已经被更新. 决定了"保存"按钮的状态
  final StreamController<bool> _dataChangedSC = StreamController();

  // 表单key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 构造方法
  BaseInfoState(this.id);

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
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: _buildForm(),
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
                          account.sitePinYinName = PinyinHelper.getPinyinE(account.siteName);
                          account.password = account.password.trim();
                          account.updateTime = DateTime.now().toString();
                          db.accountDao.add(account).then((id) {
                            // 更新数据
                            this.id = id;
                            this.account.id = id;
                            _dataChangedSC.sink.add(false);
                            Fluttertoast.showToast(msg: '保存成功');
                            // 更新历史密码
                            _recordOldPassword(account);
                            // 通知父组件
                            IdChangeNotification(id).dispatch(context);
                          });
                        });
                      }
                    : null,
              ));
            },
          ),
          _buildButton(
            OutlinedButton(
              child: Text('删 除'),
              style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: id == 0 ? null : () => _deleteAccount(),
            ),
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
              controller: TextEditingController(text: this.account.siteName),
              onChanged: (value) {
                if (account.siteName == value) {
                  return;
                }
                account.siteName = value;
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
              controller: TextEditingController(text: this.account.userName),
              onChanged: (value) {
                if (account.userName == value) {
                  return;
                }
                account.userName = value;
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

  _buildButton(Widget btnWidget) {
    return Row(
      children: [
        Expanded(
          child: btnWidget,
        )
      ],
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
                  db.accountBindingDao.deleteByAccountId(id);
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

  void _recordOldPassword(Account account) {
    if (account.password.isEmpty) {
      return;
    }
    DatabaseUtils.getDatabase().then((db) {
      db.oldPasswordDao.findByAccountId(id).then((oldPasswordList) {
        if (oldPasswordList.isEmpty || oldPasswordList[0].password != account.password) {
          db.oldPasswordDao.add(OldPassword(null, id, account.password, DateTime.now().toString(), ''));
        }
      });
    });
  }
}
