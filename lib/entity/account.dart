import 'package:floor/floor.dart';
import 'package:my_password_flutter/utils/constants.dart';

@entity
class Account {
  @PrimaryKey(autoGenerate: true)
  int? id;
  String site_name = '';
  String site_pin_yin_name = '';
  String user_name = '';
  String password = '';
  String remarks = '';
  String create_time = '';
  String update_time = '';
  String memo = '';

  Account(this.id, this.site_name, this.site_pin_yin_name, this.user_name, this.password, this.remarks, this.create_time, this.update_time, this.memo);

  static Account ofEmpty() {
    Account account = Account(null, '', '', '', '', '', '', '', '');
    return account;
  }

  String getTagChar() {
    var firstChar = this.site_pin_yin_name.isEmpty ? Constants.keywordNo : this.site_pin_yin_name.substring(0, 1);
    var firstCharUpperCase = firstChar.toUpperCase();
    return Constants.keywordList.contains(firstCharUpperCase) ? firstCharUpperCase : Constants.keywordNo;
  }

  Account.fromJson(Map<String, dynamic> map)
      : id = map["id"] ?? '',
        site_name = map["siteName"] ?? '',
        site_pin_yin_name = map["sitePinYinName"] ?? '',
        user_name = map["userName"] ?? '',
        password = map["password"] ?? '',
        remarks = map["remarks"] ?? '',
        create_time = map["createTime"] ?? '',
        update_time = map["updateTime"] ?? '',
        memo = map["memo"] ?? '';

  Map<String, dynamic> toJson() => {
        "id": id,
        "siteName": site_name,
        "sitePinYinName": site_pin_yin_name,
        "userName": user_name,
        "password": password,
        "remarks": remarks,
        "createTime": create_time,
        "updateTime": update_time,
        "memo": memo
      };

  @override
  String toString() {
    return 'Account{id: $id, site_name: $site_name, site_pin_yin_name: $site_pin_yin_name, user_name: $user_name, password: $password, remarks: $remarks, create_time: $create_time, update_time: $update_time, memo: $memo}';
  }
}
