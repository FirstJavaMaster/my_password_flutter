import 'package:floor/floor.dart';
import 'package:my_password_flutter/utils/constants.dart';

@entity
class Account {
  @PrimaryKey(autoGenerate: true)
  int? id;
  String siteName = '';
  String sitePinYinName = '';
  String userName = '';
  String password = '';
  String remarks = '';
  String createTime = '';
  String updateTime = '';
  String memo = '';

  Account(this.id, this.siteName, this.sitePinYinName, this.userName, this.password, this.remarks, this.createTime, this.updateTime, this.memo);

  static Account ofEmpty() {
    Account account = Account(null, '', '', '', '', '', '', '', '');
    return account;
  }

  /// 获取当前account的tag, 可用于分组和筛选
  /// 根据account的sitePinYinName的首字母进行判断, 如果是数字, 则返回#
  /// 默认是大写
  /// 返回的一定是Constants.keywordList内的元素
  String getTagChar() {
    var firstChar = this.sitePinYinName.isEmpty ? Constants.keywordNo : this.sitePinYinName.substring(0, 1);
    var firstCharUpperCase = firstChar.toUpperCase();
    return Constants.keywordList.contains(firstCharUpperCase) ? firstCharUpperCase : Constants.keywordNo;
  }

  Account.fromJson(Map<String, dynamic> map)
      : id = map["id"] ?? '',
        siteName = map["siteName"] ?? '',
        sitePinYinName = map["sitePinYinName"] ?? '',
        userName = map["userName"] ?? '',
        password = map["password"] ?? '',
        remarks = map["remarks"] ?? '',
        createTime = map["createTime"] ?? '',
        updateTime = map["updateTime"] ?? '',
        memo = map["memo"] ?? '';

  Map<String, dynamic> toJson() => {
        "id": id,
        "siteName": siteName,
        "sitePinYinName": sitePinYinName,
        "userName": userName,
        "password": password,
        "remarks": remarks,
        "createTime": createTime,
        "updateTime": updateTime,
        "memo": memo
      };

  @override
  String toString() {
    return 'Account{id: $id, siteName: $siteName, sitePinYinName: $sitePinYinName, userName: $userName, password: $password, remarks: $remarks, createTime: $createTime, updateTime: $updateTime, memo: $memo}';
  }
}
