import 'package:floor/floor.dart';
import 'package:my_password_flutter/entity/account_binding.dart';

@dao
abstract class AccountBindingDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> add(AccountBinding accountRelation);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addList(List<AccountBinding> accountBindingList);

  @Query('SELECT * FROM AccountBinding WHERE id = :id')
  Future<AccountBinding?> findById(int id);

  @Query('SELECT * FROM AccountBinding WHERE sourceId = :sourceId')
  Future<List<AccountBinding>> findListBySourceId(int sourceId);

  @Query('SELECT * FROM AccountBinding')
  Future<List<AccountBinding>> findAll();

  @delete
  Future<int> deleteByEntity(AccountBinding accountRelation);

  @Query('DELETE FROM AccountBinding WHERE sourceId = :accountId or targetId = :accountId')
  Future<void> deleteByAccountId(int accountId);
}
