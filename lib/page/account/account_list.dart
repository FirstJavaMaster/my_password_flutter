import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/page/account/account.dart';

class AccountListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AccountListPageState();
  }
}

class AccountListPageState extends State<AccountListPage> {
  List<Account> accountList = [];

  @override
  void initState() {
    super.initState();
    _getAccountList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('My Password'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountPage(0))).then((value) => _dealRouterReturn(value));
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _getAccountList();
        },
        child: _buildRowList(),
      ),
    );
  }

  // 查询列表
  void _getAccountList() {
    DatabaseUtils.getDatabase().then((db) => {
          db.accountDao.findAll().then((accountList) => {
                setState(() {
                  this.accountList = accountList;
                })
              })
        });
  }

  Widget _buildRowList() {
    return ListView.separated(
      itemCount: accountList.length,
      itemBuilder: (context, index) {
        Account account = this.accountList[index];
        return new ListTile(
          title: new Text(
            account.id.toString() + "、" + account.site_name,
          ),
          subtitle: Row(
            children: [
              InkWell(
                child: Text(
                  account.user_name,
                  textScaleFactor: 1.2,
                  style: TextStyle(height: 1.5),
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: account.user_name)).then((value) => Fluttertoast.showToast(msg: '已复制到剪切板'));
                },
              ),
              Text(' - '),
              InkWell(
                child: Text(
                  account.password,
                  textScaleFactor: 1.2,
                  style: TextStyle(height: 1.5),
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: account.password)).then((value) => Fluttertoast.showToast(msg: '已复制到剪切板'));
                },
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountPage(account.id ?? 0))).then((value) => _dealRouterReturn(value));
            },
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(height: 1),
    );
  }

  void _dealRouterReturn(value) {
    _getAccountList();
  }
}
