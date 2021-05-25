import 'package:floor/floor.dart';
import 'package:my_password_flutter/entity/account_relation.dart';

@dao
abstract class AccountRelationDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> add(AccountRelation accountRelation);

  @Query('SELECT * FROM AccountRelation')
  Future<List<AccountRelation>> findAll();

  @Query('SELECT * FROM AccountRelation WHERE id = :id')
  Future<AccountRelation?> findById(int id);
}
