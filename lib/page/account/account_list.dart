import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/page/account/account.dart';
import 'package:my_password_flutter/page/account/main_drawer.dart';
import 'package:my_password_flutter/page/components/gradient_bar.dart';
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
        flexibleSpace: GradientBar.gradientBar,
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
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 500));
          _getAccountList(showToast: true);
        },
        child: Stack(
          alignment: Alignment.center,
          // 未指定位置的子元素会自动占满Stack空间
          fit: StackFit.expand,
          children: [
            // 默认是透明, 改成白色, 可以防止"透视"
            Container(
              color: Colors.white,
              child: _buildPartList(),
            ),
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
    if (showToast) {
      Fluttertoast.showToast(msg: '已刷新', gravity: ToastGravity.CENTER);
    }
  }

  Widget _buildPartList() {
    return ScrollablePositionedList.builder(
      itemCount: this.accountIndexList.length + 1,
      itemBuilder: (context, index) {
        // 最后一个列表项
        if (index == this.accountIndexList.length) {
          return _buildTailMemo();
        }

        var accountIndex = this.accountIndexList[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPartTitle(accountIndex),
            _buildRowList(accountIndex),
          ],
        );
      },
      itemScrollController: _itemScrollController,
    );
  }

  Widget _buildPartTitle(String accountIndex) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.black12),
      width: double.infinity,
      // (点击"用户名"/"密码"可以快捷复制)
      child: Row(
        children: [
          Text(accountIndex, textScaleFactor: 1.2),
          Text('  (点击"用户名"/"密码"可以快捷复制)', style: TextStyle(color: Colors.black45)),
        ],
      ),
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
          overflow: TextOverflow.fade,
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
      child: Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5),
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
      ),
    );
  }

  Widget _buildTailMemo() {
    return Padding(
      padding: EdgeInsets.only(top: 40, bottom: 100),
      child: Center(
        child: GestureDetector(
          child: Column(
            children: [
              Text(this.accountList.isEmpty ? '什么都没有, 点击下方按钮添加一个吧' : '已经到底了, 点我刷新'),
              Text('_(:* ｣∠)_'),
            ],
          ),
          onTap: () => _getAccountList(showToast: true),
        ),
      ),
    );
  }
}
