// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:my_password_flutter/dao/account_dao.dart';
import 'package:my_password_flutter/dao/account_binding_dao.dart';
import 'package:my_password_flutter/dao/old_password_dao.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:my_password_flutter/entity/account_binding.dart';
import 'package:my_password_flutter/entity/old_password.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Account, AccountBinding, OldPassword])
abstract class AppDatabase extends FloorDatabase {
  AccountDao get accountDao;

  AccountBindingDao get accountBindingDao;

  OldPasswordDao get oldPasswordDao;
}
