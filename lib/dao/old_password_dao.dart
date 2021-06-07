import 'package:floor/floor.dart';
import 'package:my_password_flutter/entity/old_password.dart';

@dao
abstract class OldPasswordDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> add(OldPassword oldPassword);

  @Query('SELECT * FROM OldPassword WHERE accountId = :accountId ORDER BY beginTime DESC')
  Future<List<OldPassword>> findByAccountId(int accountId);

  @delete
  Future<int> deleteByEntity(OldPassword oldPassword);
}
