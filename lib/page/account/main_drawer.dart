import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_password_flutter/utils/import_export_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
              gradient: LinearGradient(
                colors: [Color(0xFF9708CC), Color(0xFF43CBFF)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('images/logo.jpg'),
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
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('关于本软件'),
            onTap: () => _showAppInfoDialog(context),
          )
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
    bool importResult = await ImportExportUtils.importData(filePath);
    // 故意加长耗时, 否则接下来的查询可能会"不生效", 而且太快的话给人一种"不真实感"
    await Future.delayed(Duration(seconds: 1));
    // 关闭等待框
    if (dialogContext != null) {
      Navigator.pop(dialogContext!);
    }
    Fluttertoast.showToast(msg: importResult ? '导入成功' : '导入失败', gravity: ToastGravity.CENTER);
    return importResult;
  }

  void exportFile(BuildContext mainContext) async {
    // 执行导出
    var exportFilePath = await ImportExportUtils.exportData();
    if (exportFilePath.isEmpty) {
      return;
    }

    // 提示用户
    showDialog<bool>(
      context: mainContext,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("为保证数据安全, 导出文件不会放在公共目录, 建议分享至其他平台进行备份, 如私人邮箱/QQ/微信/云存储等"),
          actions: <Widget>[
            TextButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("导出"),
              onPressed: () {
                Navigator.of(context).pop(true);
                Share.shareFiles([exportFilePath]);
              },
            ),
          ],
        );
      },
    );
  }

  // 根据当前时间, 返回导出文件的绝对路径
  Future<String> getExportFilePath() async {
    var docPath = (await getApplicationDocumentsDirectory()).path;

    var now = DateTime.now();
    String filename = 'my-password-backup.${now.year}${now.month}${now.day}.${now.hour}-${now.minute}-${now.second}.json';
    return docPath + '/export/' + filename;
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text('My Password 1.0')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('本软件提供密码记录功能, 操作简单便捷. 主要有以下特性:'),
              SizedBox(height: 10),
              Text('  •  高级索引列表, 支持汉语拼音索引, 内容再多也能快速定位'),
              Text('  •  支持账号关联, 记录各个网站的第三方登陆方式'),
              Text('  •  自动记录历史密码, 快速找到以前的你'),
              SizedBox(height: 10),
              Text('隐私保护说明', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('用户数据始终保存在应用私有空间, 其他应用无法访问; 整个使用过程不会联网, 因此建议定时导出文件并分享至私人邮箱/QQ/微信/云存储等其他平台进行备份.', textScaleFactor: 0.8),
              SizedBox(height: 10),
              Text('开源地址'),
              TextButton(
                onPressed: () {
                  String urlString = 'https://github.com/FirstJavaMaster/my_password_flutter';
                  canLaunch(urlString).then((value) => value ? launch(urlString) : Fluttertoast.showToast(msg: '无法跳转'));
                },
                child: Text('https://github.com/FirstJavaMaster/my_password_flutter'),
              ),
              SizedBox(height: 10),
              Text('2021 夏  •  by Tong'),
            ],
          ),
        );
      },
    );
  }
}
