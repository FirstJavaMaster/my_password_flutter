// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
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

  AccountBindingDao? _accountBindingDaoInstance;

  OldPasswordDao? _oldPasswordDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `Account` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `siteName` TEXT NOT NULL, `sitePinYinName` TEXT NOT NULL, `userName` TEXT NOT NULL, `password` TEXT NOT NULL, `remarks` TEXT NOT NULL, `createTime` TEXT NOT NULL, `updateTime` TEXT NOT NULL, `memo` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AccountBinding` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `sourceId` INTEGER NOT NULL, `targetId` INTEGER NOT NULL, `memo` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `OldPassword` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `accountId` INTEGER NOT NULL, `password` TEXT NOT NULL, `beginTime` TEXT NOT NULL, `memo` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AccountDao get accountDao {
    return _accountDaoInstance ??= _$AccountDao(database, changeListener);
  }

  @override
  AccountBindingDao get accountBindingDao {
    return _accountBindingDaoInstance ??=
        _$AccountBindingDao(database, changeListener);
  }

  @override
  OldPasswordDao get oldPasswordDao {
    return _oldPasswordDaoInstance ??=
        _$OldPasswordDao(database, changeListener);
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
                  'siteName': item.siteName,
                  'sitePinYinName': item.sitePinYinName,
                  'userName': item.userName,
                  'password': item.password,
                  'remarks': item.remarks,
                  'createTime': item.createTime,
                  'updateTime': item.updateTime,
                  'memo': item.memo
                }),
        _accountDeletionAdapter = DeletionAdapter(
            database,
            'Account',
            ['id'],
            (Account item) => <String, Object?>{
                  'id': item.id,
                  'siteName': item.siteName,
                  'sitePinYinName': item.sitePinYinName,
                  'userName': item.userName,
                  'password': item.password,
                  'remarks': item.remarks,
                  'createTime': item.createTime,
                  'updateTime': item.updateTime,
                  'memo': item.memo
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Account> _accountInsertionAdapter;

  final DeletionAdapter<Account> _accountDeletionAdapter;

  @override
  Future<List<Account>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM Account',
        mapper: (Map<String, Object?> row) => Account(
            row['id'] as int?,
            row['siteName'] as String,
            row['sitePinYinName'] as String,
            row['userName'] as String,
            row['password'] as String,
            row['remarks'] as String,
            row['createTime'] as String,
            row['updateTime'] as String,
            row['memo'] as String));
  }

  @override
  Future<Account?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM Account WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Account(
            row['id'] as int?,
            row['siteName'] as String,
            row['sitePinYinName'] as String,
            row['userName'] as String,
            row['password'] as String,
            row['remarks'] as String,
            row['createTime'] as String,
            row['updateTime'] as String,
            row['memo'] as String),
        arguments: [id]);
  }

  @override
  Future<int> add(Account account) {
    return _accountInsertionAdapter.insertAndReturnId(
        account, OnConflictStrategy.replace);
  }

  @override
  Future<void> addList(List<Account> account) async {
    await _accountInsertionAdapter.insertList(
        account, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteByEntity(Account account) {
    return _accountDeletionAdapter.deleteAndReturnChangedRows(account);
  }
}

class _$AccountBindingDao extends AccountBindingDao {
  _$AccountBindingDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _accountBindingInsertionAdapter = InsertionAdapter(
            database,
            'AccountBinding',
            (AccountBinding item) => <String, Object?>{
                  'id': item.id,
                  'sourceId': item.sourceId,
                  'targetId': item.targetId,
                  'memo': item.memo
                }),
        _accountBindingDeletionAdapter = DeletionAdapter(
            database,
            'AccountBinding',
            ['id'],
            (AccountBinding item) => <String, Object?>{
                  'id': item.id,
                  'sourceId': item.sourceId,
                  'targetId': item.targetId,
                  'memo': item.memo
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AccountBinding> _accountBindingInsertionAdapter;

  final DeletionAdapter<AccountBinding> _accountBindingDeletionAdapter;

  @override
  Future<AccountBinding?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM AccountBinding WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AccountBinding(
            row['id'] as int?,
            row['sourceId'] as int,
            row['targetId'] as int,
            row['memo'] as String),
        arguments: [id]);
  }

  @override
  Future<List<AccountBinding>> findListBySourceId(int sourceId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM AccountBinding WHERE sourceId = ?1',
        mapper: (Map<String, Object?> row) => AccountBinding(
            row['id'] as int?,
            row['sourceId'] as int,
            row['targetId'] as int,
            row['memo'] as String),
        arguments: [sourceId]);
  }

  @override
  Future<List<AccountBinding>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM AccountBinding',
        mapper: (Map<String, Object?> row) => AccountBinding(
            row['id'] as int?,
            row['sourceId'] as int,
            row['targetId'] as int,
            row['memo'] as String));
  }

  @override
  Future<void> deleteByAccountId(int accountId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM AccountBinding WHERE sourceId = ?1 or targetId = ?1',
        arguments: [accountId]);
  }

  @override
  Future<int> add(AccountBinding accountRelation) {
    return _accountBindingInsertionAdapter.insertAndReturnId(
        accountRelation, OnConflictStrategy.replace);
  }

  @override
  Future<void> addList(List<AccountBinding> accountBindingList) async {
    await _accountBindingInsertionAdapter.insertList(
        accountBindingList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteByEntity(AccountBinding accountRelation) {
    return _accountBindingDeletionAdapter
        .deleteAndReturnChangedRows(accountRelation);
  }
}

class _$OldPasswordDao extends OldPasswordDao {
  _$OldPasswordDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _oldPasswordInsertionAdapter = InsertionAdapter(
            database,
            'OldPassword',
            (OldPassword item) => <String, Object?>{
                  'id': item.id,
                  'accountId': item.accountId,
                  'password': item.password,
                  'beginTime': item.beginTime,
                  'memo': item.memo
                }),
        _oldPasswordDeletionAdapter = DeletionAdapter(
            database,
            'OldPassword',
            ['id'],
            (OldPassword item) => <String, Object?>{
                  'id': item.id,
                  'accountId': item.accountId,
                  'password': item.password,
                  'beginTime': item.beginTime,
                  'memo': item.memo
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<OldPassword> _oldPasswordInsertionAdapter;

  final DeletionAdapter<OldPassword> _oldPasswordDeletionAdapter;

  @override
  Future<List<OldPassword>> findByAccountId(int accountId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM OldPassword WHERE accountId = ?1 ORDER BY beginTime DESC, id DESC',
        mapper: (Map<String, Object?> row) => OldPassword(row['id'] as int?, row['accountId'] as int, row['password'] as String, row['beginTime'] as String, row['memo'] as String),
        arguments: [accountId]);
  }

  @override
  Future<List<OldPassword>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM OldPassword',
        mapper: (Map<String, Object?> row) => OldPassword(
            row['id'] as int?,
            row['accountId'] as int,
            row['password'] as String,
            row['beginTime'] as String,
            row['memo'] as String));
  }

  @override
  Future<int> add(OldPassword oldPassword) {
    return _oldPasswordInsertionAdapter.insertAndReturnId(
        oldPassword, OnConflictStrategy.replace);
  }

  @override
  Future<void> addList(List<OldPassword> oldPasswordList) async {
    await _oldPasswordInsertionAdapter.insertList(
        oldPasswordList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteByEntity(OldPassword oldPassword) {
    return _oldPasswordDeletionAdapter.deleteAndReturnChangedRows(oldPassword);
  }
}
