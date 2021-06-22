import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/page/account/account.dart';
import 'package:my_password_flutter/page/account/main_drawer.dart';
import 'package:my_password_flutter/utils/constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AccountListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AccountListPageState();
  }
}

class AccountListPageState extends State<AccountListPage> {
  // 账户列表
  List<Account> accountList = [];

  // 账户索引列表
  List<String> accountIndexList = [];

  // 滚动控制器
  final ItemScrollController _itemScrollController = ItemScrollController();

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
      drawer: MainDrawer((closeResult) => _getAccountList()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountPage(0))).then((value) => _getAccountList());
          var nextInt = Random().nextInt(this.accountIndexList.length - 1);
          Fluttertoast.showToast(msg: "下一个索引: " + this.accountIndexList[nextInt]);
          _itemScrollController.scrollTo(index: nextInt, duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _getAccountList();
        },
        child: _buildPart(),
      ),
    );
  }

  // 查询列表
  void _getAccountList() {
    DatabaseUtils.getDatabase().then((db) => {
          db.accountDao.findAll().then((accountList) => {
                setState(() {
                  this.accountList = accountList;
                  var indexOfFirstCharSet = accountList.map((e) {
                    var indexOfFirstChar = Constants.keywordList.indexOf(e.getTagChar());
                    return indexOfFirstChar < 0 ? 0 : indexOfFirstChar;
                  }).toSet();
                  this.accountIndexList = Constants.keywordList.where((e) => indexOfFirstCharSet.contains(Constants.keywordList.indexOf(e))).toList();
                })
              })
        });
  }

  Widget _buildPart() {
    return ScrollablePositionedList.builder(
      itemCount: this.accountIndexList.length + 1,
      itemBuilder: (context, index) {
        // 最后一个列表项
        if (index == accountIndexList.length) {
          return SizedBox(
            height: 150,
            child: Center(
              child: Text('没有更多了 (＞﹏＜)'),
            ),
          );
        }

        var accountIndex = this.accountIndexList[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.black12),
              width: double.infinity,
              child: Text(
                accountIndex,
                textScaleFactor: 1.2,
              ),
            ),
            _buildRowList(accountIndex),
          ],
        );
      },
      itemScrollController: _itemScrollController,
    );
  }

  Widget _buildRowList(String accountIndex) {
    var accountListCurrent = this.accountList.where((element) => accountIndex == element.getTagChar()).toList();
    return Column(
      children: () {
        List<Widget> rowList = accountListCurrent.map((account) {
          return ListTile(
            title: new Text(account.site_name),
            subtitle: Row(
              children: [
                _buildSubtitle(account.user_name),
                Text(' - '),
                _buildSubtitle(account.password),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountPage(account.id ?? 0))).then((value) => _getAccountList());
              },
            ),
          );
        }).toList();

        // 向其中混入分割线
        List<Widget> superRowList = [];
        rowList.forEach((row) {
          superRowList.add(row);
          superRowList.add(Divider(height: 1));
        });
        return superRowList;
      }(),
    );
  }

  _buildSubtitle(String content) {
    return InkWell(
      child: Text(
        content,
        textScaleFactor: 1.2,
        style: TextStyle(height: 1.5),
      ),
      onTap: () {
        Clipboard.setData(ClipboardData(text: content)).then((value) => Fluttertoast.showToast(msg: '[$content] 已复制到剪切板'));
      },
    );
  }
}
