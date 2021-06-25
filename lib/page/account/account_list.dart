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
      drawer: MainDrawer((dataChanged) => _getAccountList()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountPage(0))).then((value) => _getAccountList());
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async => _getAccountList(showToast: true),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildPart(),
            Positioned(
              right: 10,
              child: _buildIndexBar(),
            )
          ],
        ),
      ),
    );
  }

  // 查询列表
  void _getAccountList({bool showToast = false}) async {
    var db = await DatabaseUtils.getDatabase();
    var accountList = await db.accountDao.findAll();
    setState(() {
      this.accountList = accountList;
      var indexOfFirstCharSet = accountList.map((e) {
        var indexOfFirstChar = Constants.keywordList.indexOf(e.getTagChar());
        return indexOfFirstChar < 0 ? 0 : indexOfFirstChar;
      }).toSet();
      this.accountIndexList = Constants.keywordList.where((e) => indexOfFirstCharSet.contains(Constants.keywordList.indexOf(e))).toList();
    });
    await Future.delayed(Duration(milliseconds: 500));
    if (showToast) {
      Fluttertoast.showToast(msg: '已刷新', gravity: ToastGravity.CENTER);
    }
  }

  Widget _buildPart() {
    return ScrollablePositionedList.builder(
      itemCount: this.accountIndexList.length + 1,
      itemBuilder: (context, index) {
        // 最后一个列表项
        if (index == accountIndexList.length) {
          return _buildTailMemo();
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
            title: new Text(account.siteName),
            subtitle: Row(
              children: [
                _buildSubtitle(account.userName),
                Text(' - '),
                _buildSubtitle(account.password),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountPage(account.id ?? 0))).then((value) => _getAccountList());
            },
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
      child: LimitedBox(
        maxWidth: MediaQuery.of(context).size.width / 2 - 30,
        child: Text(
          content,
          textScaleFactor: 1.2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(height: 1.5),
        ),
      ),
      onTap: () {
        Clipboard.setData(ClipboardData(text: content)).then((value) => Fluttertoast.showToast(msg: '[$content] 已复制到剪切板'));
      },
    );
  }

  Widget _buildIndexBar() {
    return Card(
      child: Column(
        children: () {
          return this.accountIndexList.map((index) {
            return InkWell(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: Text(index),
              ),
              onTap: () {
                Fluttertoast.showToast(msg: '选择 $index', gravity: ToastGravity.CENTER, fontSize: 16);
                var indexOfIndex = this.accountIndexList.indexOf(index);
                _itemScrollController.scrollTo(index: indexOfIndex, duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
              },
            );
          }).toList();
        }(),
      ),
    );
  }

  Widget _buildTailMemo() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 40, 0, 100),
      child: Center(
        child: Text('没有更多了 (＞﹏＜)'),
      ),
    );
  }
}
