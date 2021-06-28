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

  OldPassword.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        accountId = json['accountId'],
        password = json['password'],
        beginTime = json['beginTime'] ?? DateTime.now().toString(),
        memo = json['memo'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'accountId': accountId,
        'password': password,
        'beginTime': beginTime,
        'memo': memo,
      };

  @override
  String toString() {
    return 'OldPassword{id: $id, accountId: $accountId, password: $password, beginTime: $beginTime, memo: $memo}';
  }
}
