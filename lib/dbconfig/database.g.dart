// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AccountDao? _accountDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Account` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `site_name` TEXT NOT NULL, `site_pin_yin_name` TEXT NOT NULL, `user_name` TEXT NOT NULL, `password` TEXT NOT NULL, `remarks` TEXT NOT NULL, `create_time` TEXT NOT NULL, `update_time` TEXT NOT NULL, `memo` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AccountDao get accountDao {
    return _accountDaoInstance ??= _$AccountDao(database, changeListener);
  }
}

class _$AccountDao extends AccountDao {
  _$AccountDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _accountInsertionAdapter = InsertionAdapter(
            database,
            'Account',
            (Account item) => <String, Object?>{
                  'id': item.id,
                  'site_name': item.site_name,
                  'site_pin_yin_name': item.site_pin_yin_name,
                  'user_name': item.user_name,
                  'password': item.password,
                  'remarks': item.remarks,
                  'create_time': item.create_time,
                  'update_time': item.update_time,
                  'memo': item.memo
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Account> _accountInsertionAdapter;

  @override
  Future<List<Account>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM Account',
        mapper: (Map<String, Object?> row) => Account(
            row['id'] as int?,
            row['site_name'] as String,
            row['site_pin_yin_name'] as String,
            row['user_name'] as String,
            row['password'] as String,
            row['remarks'] as String,
            row['create_time'] as String,
            row['update_time'] as String,
            row['memo'] as String));
  }

  @override
  Future<Account?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM Account WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Account(
            row['id'] as int?,
            row['site_name'] as String,
            row['site_pin_yin_name'] as String,
            row['user_name'] as String,
            row['password'] as String,
            row['remarks'] as String,
            row['create_time'] as String,
            row['update_time'] as String,
            row['memo'] as String),
        arguments: [id]);
  }

  @override
  Future<int> add(Account account) {
    return _accountInsertionAdapter.insertAndReturnId(
        account, OnConflictStrategy.replace);
  }
}
