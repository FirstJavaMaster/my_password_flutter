import 'package:floor/floor.dart';

@entity
class OldPassword {
  @PrimaryKey(autoGenerate: true)
  int? id;
  int accountId;
  String password;
  String beginTime;
  String memo;

  OldPassword(this.id, this.accountId, this.password, this.beginTime, this.memo);

  @override
  String toString() {
    return 'OldPassword{id: $id, accountId: $accountId, password: $password, beginTime: $beginTime, memo: $memo}';
  }
}
