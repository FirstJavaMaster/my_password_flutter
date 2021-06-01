import 'package:flutter/material.dart';
import 'package:my_password_flutter/page/account_info.dart';
import 'package:my_password_flutter/page/account_old_password_list.dart';
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

  AccountState(this.id);

  @override
  Widget build(BuildContext context) {
    // DefaultTabController作用于内部的TabBar和TabBarView
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(id == 0 ? '创建账号' : '账号详情'),
          bottom: TabBar(
            tabs: [
              Tab(text: '基本信息'),
              Tab(text: '关联账号'),
              Tab(text: '历史密码'),
            ],
          ),
        ),
        body: NotificationListener<IdChangeNotification>(
          child: TabBarView(
            children: [
              AccountInfo(id),
              AccountRelationList(id),
              OldPasswordList(id),
            ],
          ),
          onNotification: (notification) {
            setState(() {
              this.id = notification.id;
            });
            return true;
          },
        ),
      ),
    );
  }
}

// id变化的通知类. 子组件向父组件传递消息
class IdChangeNotification extends Notification {
  final int id;

  IdChangeNotification(this.id);
}
