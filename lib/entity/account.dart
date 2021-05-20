import 'package:floor/floor.dart';

@entity
class Account {
  @primaryKey
  final int id;
  final String site_name;
  final String site_pin_yin_name;
  final String user_name;
  final String password;
  final String remarks;
  final String create_time;
  final String update_time;
  final String memo;

  Account(
      this.id,
      this.site_name,
      this.site_pin_yin_name,
      this.user_name,
      this.password,
      this.remarks,
      this.create_time,
      this.update_time,
      this.memo);

  @override
  String toString() {
    return 'Account{id: $id, site_name: $site_name, site_pin_yin_name: $site_pin_yin_name, user_name: $user_name, password: $password, remarks: $remarks, create_time: $create_time, update_time: $update_time, memo: $memo}';
  }
}
