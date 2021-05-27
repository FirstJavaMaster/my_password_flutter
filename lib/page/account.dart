import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lpinyin/lpinyin.dart';
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
  // 当前id
  int id = 0;

  // 当前 account
  Account account = Account.ofEmpty();

  // 是否数据已经被更新. 决定了"保存"按钮的状态
  bool dataChanged = false;

  // 表单key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 构造方法
  AccountState(int id) {
    this.id = id;
    DatabaseUtils.getDatabase().then((db) {
      db.accountDao.findById(this.id).then((account) {
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
        title: Text(id == 0 ? '创建账号' : '账号详情'),
      ),
      body: _buildPage(),
    );
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTitle('基本信息'),
          Card(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: _buildForm(),
            ),
          ),
          _buildTitle('关联账号'),
          Card(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: AccountRelationList(id),
            ),
          ),
          _buildButton(
            ElevatedButton(
              child: Text('保 存'),
              onPressed: dataChanged
                  ? () {
                      bool validateResult = _formKey.currentState!.validate();
                      if (!validateResult) {
                        return;
                      }
                      DatabaseUtils.getDatabase().then((db) {
                        account.site_pin_yin_name = PinyinHelper.getPinyinE(account.site_name);
                        account.update_time = DateTime.now().toString();
                        db.accountDao.add(account).then((id) => account.id = id);
                        Fluttertoast.showToast(msg: '保存成功');
                      });
                    }
                  : null,
            ),
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
              decoration: InputDecoration(labelText: '网站名称'),
              controller: TextEditingController(text: this.account.site_name),
              onChanged: (value) {
                setState(() {
                  account.site_name = value;
                  dataChanged = true;
                });
              },
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
              onChanged: (value) {
                setState(() {
                  account.user_name = value;
                  dataChanged = true;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '密码'),
              controller: TextEditingController(text: this.account.password),
              onChanged: (value) {
                setState(() {
                  account.password = value;
                  dataChanged = true;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '其他备注'),
              controller: TextEditingController(text: this.account.memo),
              onChanged: (value) {
                setState(() {
                  account.memo = value;
                  dataChanged = true;
                });
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

  _buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
      child: Text(
        title,
        textScaleFactor: 1.5,
      ),
    );
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
