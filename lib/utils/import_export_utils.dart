import 'dart:convert';
import 'dart:io';

import 'package:floor/floor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_password_flutter/dbconfig/database_utils.dart';
import 'package:my_password_flutter/dto/data_container.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/entity/account_binding.dart';
import 'package:my_password_flutter/entity/old_password.dart';
import 'package:path_provider/path_provider.dart';

class ImportExportUtils {
  // 文件导入
  static Future<bool> importData(String filePath) async {
    try {
      _doImportData(filePath);
      Fluttertoast.showToast(msg: '导入成功', gravity: ToastGravity.CENTER);
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: '导入失败', gravity: ToastGravity.CENTER);
      print(e);
      return false;
    }
  }

  @transaction
  static void _doImportData(String filePath) async {
    var content = await File(filePath).readAsString();
    var decode = json.decode(content);
    DataContainer dataContainer = DataContainer.fromJson(decode);

    var db = await DatabaseUtils.getDatabase();
    db.accountDao.addList(dataContainer.accountList);
    db.accountBindingDao.addList(dataContainer.accountBindingList);
    db.oldPasswordDao.addList(dataContainer.oldPasswordList);

    // 兼容历史密码缺失的场景
    var accountList = await db.accountDao.findAll();
    accountList.forEach((account) async {
      if (account.id == null || account.password.isEmpty) {
        return;
      }
      var oldPasswordList = await db.oldPasswordDao.findByAccountId(account.id!);
      if (oldPasswordList.isEmpty || oldPasswordList[0].password != account.password) {
        var oldPassword = OldPassword(null, account.id!, account.password, DateTime.now().toString(), '');
        db.oldPasswordDao.add(oldPassword);
      }
    });
  }

  static Future<String> exportData() async {
    try {
      return await _doExportData();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '导出失败', gravity: ToastGravity.CENTER);
      return '';
    }
  }

  // 导出
  static Future<String> _doExportData() async {
    var db = await DatabaseUtils.getDatabase();
    List<Account> accountList = await db.accountDao.findAll();
    List<AccountBinding> accountBindingList = await db.accountBindingDao.findAll();
    List<OldPassword> oldPasswordList = await db.oldPasswordDao.findAll();

    DataContainer dataContainer = DataContainer(accountList, accountBindingList, oldPasswordList);
    var jsonStr = JsonEncoder.withIndent('  ').convert(dataContainer);

    var exportFilePath = await getExportFilePath();
    var file = File(exportFilePath);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    file.writeAsString(jsonStr);
    return exportFilePath;
  }

  // 根据当前时间, 返回导出文件的绝对路径
  static Future<String> getExportFilePath() async {
    var docPath = (await getApplicationDocumentsDirectory()).path;

    var now = DateTime.now();
    String filename = 'my-password-backup.${now.year}${now.month}${now.day}.${now.hour}-${now.minute}-${now.second}.json';
    return docPath + '/export/' + filename;
  }
}
