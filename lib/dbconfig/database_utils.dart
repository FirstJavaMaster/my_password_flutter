import 'package:floor/floor.dart';

import 'database.dart';

final String dbFileName = "app_database.db";

class DatabaseUtils {
  // 数据库升级需要制定升级脚本. https://floor.codes/migrations/
  static final List<Migration> migrationList = [
    // Migration(1, 2, (database) async {
    //   await database.execute('CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL)');
    // }),
  ];

  static Future<AppDatabase> getDatabase() async {
    return await $FloorAppDatabase.databaseBuilder(dbFileName).addMigrations(migrationList).build();
  }
}
