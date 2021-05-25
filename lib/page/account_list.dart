import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/page/account.dart';

final _biggerFont = const TextStyle(fontSize: 18.0);

class AccountListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AccountListState();
  }
}

class AccountListState extends State<AccountListPage> {
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
                  print('查询列表: $accountList');
                })
              })
        });
  }

  Widget _buildRowList() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
        // 在偶数行，该函数会为单词对添加一个ListTile row.
        // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
        // 注意，在小屏幕上，分割线看起来可能比较吃力。
        itemCount: accountList.length,
        itemBuilder: (context, i) {
          // 在每一列之前，添加一个1像素高的分隔线widget
          // if (i.isOdd) return new Divider();
          return _buildRow(i);
        });
  }

  Widget _buildRow(index) {
    Account account = this.accountList[index];
    return new ListTile(
      title: new Text(
        account.id.toString() + "、" + account.site_name,
        style: _biggerFont,
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountPage(account.id ?? 0))).then((value) => _dealRouterReturn(value));
      },
    );
  }

  void _dealRouterReturn(value) {
    if (value == null || value == false || value == '') {
      return;
    }
    _getAccountList();
  }
}
