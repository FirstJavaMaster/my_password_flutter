import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/page/account/account.dart';
import 'package:my_password_flutter/page/account/main_drawer.dart';
import 'package:my_password_flutter/page/components/dynamic_ellipsis.dart';
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

  // 流
  final StreamController _contentStreamController = StreamController<DateTime>();

  // 滚动控制器
  final ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    _refreshAccountList();
  }

  @override
  void dispose() {
    super.dispose();
    _contentStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('My Password'),
        flexibleSpace: GradientBar.gradientBar,
      ),
      drawer: MainDrawer((dataChanged) => _refreshAccountList()),
      body: StreamBuilder(
        stream: _contentStreamController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          bool ready = snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done;
          return ready ? _buildMainContent() : _buildDataLoading();
        },
      ),
    );
  }

  // 查询列表
  void _refreshAccountList() async {
    var db = await DatabaseUtils.getDatabase();
    var accountList = await db.accountDao.findAll();
    // 放好数据
    this.accountList = accountList;
    Set tagCharSet = accountList.map((e) => e.getTagChar()).toSet();
    this.accountIndexList = Constants.keywordList.where((e) => tagCharSet.contains(e)).toList();
    // push事件
    _contentStreamController.sink.add(DateTime.now());
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 500));
        _refreshAccountList();
        Fluttertoast.showToast(msg: '已刷新', gravity: ToastGravity.CENTER);
      },
      child: Stack(
        alignment: Alignment.center,
        // 未指定位置的子元素会自动占满Stack空间
        fit: StackFit.expand,
        children: [
          _buildPartList(),
          Positioned(
            right: 10,
            child: _buildIndexBar(),
          ),
          // 浮动按钮, 之所以没用在Scaffold组件下, 是为了"显示/隐藏"的状态切换方便
          Positioned(
            bottom: 20,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountPage(0))).then((value) => _refreshAccountList());
              },
            ),
          )
        ],
      ),
    );
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
      itemScrollController: _scrollController,
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
          Text('  (点击"用户名"-"密码"可以快捷复制)', style: TextStyle(color: Colors.black45)),
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountPage(account.id ?? 0))).then((value) => _refreshAccountList());
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
        maxWidth: MediaQuery.of(context).size.width / 2 - 60,
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
                  Fluttertoast.showToast(msg: '跳转到 $index', gravity: ToastGravity.CENTER, fontSize: 16);
                  var indexOfIndex = this.accountIndexList.indexOf(index);
                  _scrollController.scrollTo(index: indexOfIndex, duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
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
          onTap: () {
            _refreshAccountList();
            Fluttertoast.showToast(msg: '已刷新', gravity: ToastGravity.CENTER);
          },
        ),
      ),
    );
  }

  Widget _buildDataLoading() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background-gs.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              'images/background.jpg',
              width: 200,
              height: 200,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text('数据加载中', textScaleFactor: 1.2),
          ),
          DynamicEllipsis(),
          // 占位, 将内容抬高一点, 更美观
          SizedBox(height: 100)
        ],
      ),
    );
  }
}
