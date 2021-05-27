import 'package:floor/floor.dart';
import 'package:my_password_flutter/entity/account_relation.dart';

@dao
abstract class AccountRelationDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> add(AccountRelation accountRelation);

  @Query('SELECT * FROM AccountRelation WHERE source_id = :sourceId')
  Future<List<AccountRelation>> findListBySourceId(int sourceId);

  @Query('SELECT * FROM AccountRelation WHERE id = :id')
  Future<AccountRelation?> findById(int id);

  @delete
  Future<int> deleteByEntity(AccountRelation accountRelation);

  @Query('DELETE FROM AccountRelation WHERE source_id = :accountId or target_id = :accountId')
  Future<void> deleteByAccountId(int accountId);
}