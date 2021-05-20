import 'database.dart';

final String dbFileName = "app_database.db";

class DatabaseUtils {
  static Future<AppDatabase> getDatabase() async {
    return await $FloorAppDatabase.databaseBuilder(dbFileName).build();
  }
}
