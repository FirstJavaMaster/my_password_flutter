import 'package:flutter/widgets.dart';
import 'package:my_password_flutter/entity/person.dart';

import 'dbconfig/database.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  final personDao = database.personDao;
  // final person = Person(1, 'Frank');
  // await personDao.insertPerson(person);
  final result = await personDao.findPersonById(1);
  result.first.then((value) => print(value));
}
