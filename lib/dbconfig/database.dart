// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:my_password_flutter/dao/account_dao.dart';
import 'package:my_password_flutter/entity/account.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../dao/person_dao.dart';
import '../entity/person.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Person, Account])
abstract class AppDatabase extends FloorDatabase {
  PersonDao get personDao;

  AccountDao get accountDao;
}
