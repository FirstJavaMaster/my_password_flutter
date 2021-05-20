import 'package:floor/floor.dart';
import 'package:my_password_flutter/entity/account.dart';

@dao
abstract class AccountDao {
  @insert
  Future<void> add(Account account);
}
