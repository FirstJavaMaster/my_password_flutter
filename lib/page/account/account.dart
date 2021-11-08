import 'package:flutter/material.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/page/account/base_info.dart';
import 'package:my_password_flutter/page/account/old_password_list.dart';
import 'package:my_password_flutter/page/account/binding_list.dart';
import 'package:my_password_flutter/page/components/gradient_bar.dart';

class AccountPage extends StatefulWidget {
  int id = 0;

  AccountPage(this.id);

  @override
  State<StatefulWidget> createState() {
    return new AccountPageState(id);
  }
}

class AccountPageState extends State<AccountPage> {
  int id = 0;

  AccountPageState(this.id);

  int bingingNumber = 0;

  int oldPasswordNumber = 0;

  @override
  void initState() {
    super.initState();
    // 预先查询"关联账号"和"历史密码"的数量, 在tab页上展示出来
    _queryOtherNumber();
  }

  @override
  Widget build(BuildContext context) {
    // 接收监听
    return NotificationListener<IdChangeNotification>(
      // DefaultTabController作用于内部的TabBar和TabBarView
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(id == 0 ? '创建账号' : '账号详情'),
            flexibleSpace: GradientBar.gradientBar,
            bottom: TabBar(
              tabs: [
                Tab(text: '基本信息'),
                Tab(text: '关联账号($bingingNumber)'),
                Tab(text: '历史密码($oldPasswordNumber)'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              BaseInfo(id),
              BindingList(id),
              OldPasswordList(id),
            ],
          ),
        ),
      ),
      onNotification: (notification) {
        setState(() {
          this.id = notification.id;
          _queryOtherNumber();
        });
        return true;
      },
    );
  }

  void _queryOtherNumber() async {
    if (this.id == 0) {
      return;
    }

    var appDatabase = await DatabaseUtils.getDatabase();
    var bindingList = await appDatabase.accountBindingDao.findListBySourceId(this.id);
    var oldPasswordList = await appDatabase.oldPasswordDao.findByAccountId(this.id);
    setState(() {
      this.bingingNumber = bindingList.length;
      this.oldPasswordNumber = oldPasswordList.length;
    });
  }
}

// id变化的通知类. 子组件向父组件传递消息
class IdChangeNotification extends Notification {
  final int id;

  IdChangeNotification(this.id);
}
