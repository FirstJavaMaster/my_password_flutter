import 'package:floor/floor.dart';
import 'package:my_password_flutter/entity/old_password.dart';

@dao
abstract class OldPasswordDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> add(OldPassword oldPassword);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addList(List<OldPassword> oldPasswordList);

  @Query('SELECT * FROM OldPassword WHERE accountId = :accountId ORDER BY beginTime, id DESC')
  Future<List<OldPassword>> findByAccountId(int accountId);

  @Query('SELECT * FROM OldPassword')
  Future<List<OldPassword>> findAll();

  @delete
  Future<int> deleteByEntity(OldPassword oldPassword);
}
