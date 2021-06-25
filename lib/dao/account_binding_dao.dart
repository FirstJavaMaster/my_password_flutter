import 'package:floor/floor.dart';
import 'package:my_password_flutter/entity/account_binding.dart';

@dao
abstract class AccountBindingDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> add(AccountBinding accountRelation);

  @Query('SELECT * FROM AccountRelation WHERE sourceId = :sourceId')
  Future<List<AccountBinding>> findListBySourceId(int sourceId);

  @Query('SELECT * FROM AccountRelation WHERE id = :id')
  Future<AccountBinding?> findById(int id);

  @delete
  Future<int> deleteByEntity(AccountBinding accountRelation);

  @Query('DELETE FROM AccountRelation WHERE sourceId = :accountId or targetId = :accountId')
  Future<void> deleteByAccountId(int accountId);
}
