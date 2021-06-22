import 'package:floor/floor.dart';

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

  static Account fromMap(Map<String, dynamic> map) {
    return Account(
      map["id"] ?? '',
      map["siteName"] ?? '',
      map["sitePinYinName"] ?? '',
      map["userName"] ?? '',
      map["password"] ?? '',
      map["remarks"] ?? '',
      map["createTime"] ?? '',
      map["updateTime"] ?? '',
      map["memo"] ?? '',
    );
  }

  @override
  String toString() {
    return 'Account{id: $id, site_name: $site_name, site_pin_yin_name: $site_pin_yin_name, user_name: $user_name, password: $password, remarks: $remarks, create_time: $create_time, update_time: $update_time, memo: $memo}';
  }
}
