import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/utils/json_utils.dart';

class MainDrawer extends StatelessWidget {
  final ValueChanged<bool> closeResult;

  MainDrawer(this.closeResult);

  @override
  Widget build(BuildContext context) {
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
              var mainContext = context;
              showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("提示"),
                    content: Text("导入操作将会覆盖已有数据, 确定继续吗?"),
                    actions: <Widget>[
                      TextButton(
                        child: Text("取消"),
                        onPressed: () => Navigator.of(context).pop(), // 关闭对话框
                      ),
                      TextButton(
                        child: Text("导入"),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          importFile(mainContext).then((value) {
                            print("导入结束: " + value.toString());
                            closeResult(true);
                            Navigator.of(mainContext).pop();
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
            leading: Icon(Icons.upload_file),
            title: Text('导出数据'),
            onTap: () {
              Fluttertoast.showToast(msg: 'msg');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<bool> importFile(BuildContext context) async {
    var filePickerResult = await FilePicker.platform.pickFiles();
    if (filePickerResult == null) {
      return false;
    }
    var filePath = filePickerResult.files.single.path;
    if (filePath == null) {
      Fluttertoast.showToast(msg: '所选文件路径错误: $filePath');
      return false;
    }
    // await Future.delayed(Duration(seconds: 5));
    // 展示对话框
    BuildContext? dialogContext;
    showDialog(
      context: context,
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
    var file = new File(filePath);
    var content = await file.readAsString();
    List<Account> accountList = JsonUtils.jsonToAccountList(content);
    DatabaseUtils.getDatabase().then((db) {
      accountList.forEach((account) {
        db.accountDao.add(account);
      });
    });

    print(accountList.length);
    return Future.delayed(Duration(seconds: 3), () {
      if (dialogContext != null) {
        Navigator.pop(dialogContext!);
      }
      return true;
    });
  }
}
