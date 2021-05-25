// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:my_password_flutter/dao/account_dao.dart';
import 'package:my_password_flutter/dao/account_relation_dao.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/entity/account_relation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Account, AccountRelation])
abstract class AppDatabase extends FloorDatabase {
  AccountDao get accountDao;

  AccountRelationDao get accountRelationDao;
}
