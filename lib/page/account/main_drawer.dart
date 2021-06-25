import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/utils/json_utils.dart';
import 'package:my_password_flutter/utils/path_utils.dart';
import 'package:share_plus/share_plus.dart';

class MainDrawer extends StatelessWidget {
  // 改变这个值则会触发主页面的动作
  final ValueChanged<bool> dataChanged;

  MainDrawer(this.dataChanged);

  @override
  Widget build(BuildContext context) {
    var mainContext = context;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: SizedBox(
                width: 80.0,
                height: 80.0,
                child: CircleAvatar(
                  child: Text('R'),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.playlist_add),
            title: Text('导入数据'),
            onTap: () {
              showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("提示"),
                    content: Text("导入操作将会覆盖已有数据, 确定继续吗?"),
                    actions: <Widget>[
                      TextButton(
                        child: Text("取消"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: Text("导入"),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          importFile(mainContext).then((result) {
                            if (result) {
                              dataChanged(true);
                              Navigator.of(mainContext).pop();
                            }
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('导出数据'),
            onTap: () {
              exportFile(mainContext);
            },
          ),
        ],
      ),
    );
  }

  Future<bool> importFile(BuildContext mainContext) async {
    var filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult == null) {
      return false;
    }
    var filePath = filePickerResult.files.single.path;
    if (filePath == null) {
      Fluttertoast.showToast(msg: '所选文件路径错误: $filePath');
      return false;
    }
    // 展示对话框
    BuildContext? dialogContext;
    showDialog(
      context: mainContext,
      barrierDismissible: false, //点击遮罩不关闭对话框
      builder: (context) {
        dialogContext = context;
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 26.0),
                child: Text("正在导入，请稍后..."),
              )
            ],
          ),
        );
      },
    );
    // 执行导入
    var content = await File(filePath).readAsString();
    List<Account> accountList = JsonUtils.jsonToAccountList(content);
    var db = await DatabaseUtils.getDatabase();
    db.accountDao.addList(accountList);

    await Future.delayed(Duration(seconds: 1));
    if (dialogContext != null) {
      Navigator.pop(dialogContext!);
    }
    Fluttertoast.showToast(msg: '导入成功', gravity: ToastGravity.CENTER);
    return true;
  }

  void exportFile(BuildContext mainContext) async {
    var path = await PathUtils.getExportPath() + 'account.txt';
    var db = await DatabaseUtils.getDatabase();
    var accountList = await db.accountDao.findAll();
    var jsonStr = JsonUtils.accountListToJson(accountList);

    var file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    file.writeAsString(jsonStr);
    print(1);

    // 提示用户
    showDialog<bool>(
      context: mainContext,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("为保证数据安全, 导出文件不会放在SD卡内, 建议分享至其他平台进行备份, 如私人邮箱/QQ/微信/云存储等"),
          actions: <Widget>[
            TextButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("导出"),
              onPressed: () {
                Navigator.of(context).pop(true);
                Share.shareFiles([path]);
              },
            ),
          ],
        );
      },
    );
  }
}
