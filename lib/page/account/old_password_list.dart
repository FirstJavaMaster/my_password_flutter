import 'package:flutter/material.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/entity/old_password.dart';

class OldPasswordList extends StatefulWidget {
  int accountId;

  OldPasswordList(this.accountId);

  @override
  State<StatefulWidget> createState() {
    return OldPasswordState(accountId);
  }
}

class OldPasswordState extends State<OldPasswordList> {
  int accountId;

  List<OldPassword> oldPasswordList = [];

  OldPasswordState(this.accountId);

  @override
  void initState() {
    super.initState();
    DatabaseUtils.getDatabase().then((db) {
      db.oldPasswordDao.findByAccountId(accountId).then((oldPasswordList) {
        setState(() {
          this.oldPasswordList = oldPasswordList;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return this.accountId == 0
        ? Center(child: Text('< < 请先保存基本信息'))
        : ListView.separated(
            itemCount: oldPasswordList.length,
            itemBuilder: (context, index) {
              OldPassword oldPassword = oldPasswordList[index];
              return ListTile(
                title: Text(
                  oldPassword.password,
                  textScaleFactor: 1.2,
                ),
                trailing: Text(oldPassword.beginTime.split('.')[0]),
              );
            },
            separatorBuilder: (context, index) => Divider(height: 1),
          );
  }
}
