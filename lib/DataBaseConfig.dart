import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final Future<Database> database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    // 设置数据库的路径。注意：使用 `path` 包中的 `join` 方法是
    // 确保在多平台上路径都正确的最佳实践。
    join(await getDatabasesPath(), 'doggie_database.db'),
    // When the database is first created, create a table to store dogs.
    // 当数据库第一次被创建的时候，创建一个数据表，用以存储狗狗们的数据。
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    // 设置版本。它将执行 onCreate 方法，同时提供数据库升级和降级的路径。
    version: 1,
  );
  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database (获得数据库引用)
    final Database db = await database;
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    // 在正确的数据表里插入狗狗的数据。我们也要在这个操作中指定 `conflictAlgorithm` 策略。
    // 如果同样的狗狗数据被多次插入，后一次插入的数据将会覆盖之前的数据。
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> dogs() async {
    // Get a reference to the database (获得数据库引用)
    final Database db = await database;
    // Query the table for all The Dogs (查询数据表，获取所有的狗狗们)
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    // Convert the List<Map<String, dynamic> into a List<Dog> (将 List<Map<String, dynamic> 转换成 List<Dog> 数据类型)
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  Future<void> updateDog(Dog dog) async {
    // Get a reference to the database (获得数据库引用)
    final db = await database;
    // Update the given Dog (修改给定的狗狗的数据)
    await db.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id (确定给定的狗狗id是否匹配)
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection (通过 whereArg 传递狗狗的 id 可以防止 SQL 注入)
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    // Get a reference to the database (获得数据库引用)
    final db = await database;
    // Remove the Dog from the database (将狗狗从数据库移除)
    await db.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog (使用 `where` 语句删除指定的狗狗)
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection (通过 `whereArg` 将狗狗的 id 传递给 `delete` 方法，以防止 SQL 注入)
      whereArgs: [id],
    );
  }

  var fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );
  // Insert a dog into the database (在数据库插入一条狗狗的数据)
  await insertDog(fido);
  // Print the list of dogs (only Fido for now) [打印一个列表的狗狗们 (现在列表里只有一只叫 Fido 的狗狗)]
  print(await dogs());
  // Update Fido's age and save it to the database (修改数据库中 Fido 的年龄并且保存)
  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await updateDog(fido);
  // Print Fido's updated information (打印 Fido 的修改后的信息)
  print(await dogs());
  // Delete Fido from the database (从数据库中删除 Fido)
  await deleteDog(fido.id);
  // Print the list of dogs (empty) [打印一个列表的狗狗们 (这里已经空了)]
  print(await dogs());
}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({this.id, this.name, this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  // 重写 toString 方法，以便使用 print 方法查看每个狗狗信息的时候能更清晰。
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
