// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorUserDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$UserDatabaseBuilder databaseBuilder(String name) =>
      _$UserDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$UserDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$UserDatabaseBuilder(null);
}

class _$UserDatabaseBuilder {
  _$UserDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$UserDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$UserDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<UserDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$UserDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$UserDatabase extends UserDatabase {
  _$UserDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDAO? _userDAOInstance;

  CarDAO? _carDAOInstance;

  ObdDAO? _obdDAOInstance;

  CarUserDAO? _caruserDAOInstance;

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
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `lastName` TEXT NOT NULL, `phoneNumber` TEXT NOT NULL, `email` TEXT NOT NULL, `birthday` TEXT NOT NULL, `adresse` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Car` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `model` TEXT NOT NULL, `year` TEXT NOT NULL, `license_Plate` TEXT NOT NULL, `initial_mileage` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `OBD` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `speed` TEXT NOT NULL, `rpm` TEXT NOT NULL, `CoolantTemperature` TEXT NOT NULL, `ModuleVoltage` TEXT NOT NULL, `date_debut` TEXT NOT NULL, `date_fin` TEXT NOT NULL, `car_id` INTEGER NOT NULL, FOREIGN KEY (`car_id`) REFERENCES `OBD` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CarUser` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `user_id` INTEGER NOT NULL, `car_id` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `User` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`car_id`) REFERENCES `Car` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDAO get userDAO {
    return _userDAOInstance ??= _$UserDAO(database, changeListener);
  }

  @override
  CarDAO get carDAO {
    return _carDAOInstance ??= _$CarDAO(database, changeListener);
  }

  @override
  ObdDAO get obdDAO {
    return _obdDAOInstance ??= _$ObdDAO(database, changeListener);
  }

  @override
  CarUserDAO get caruserDAO {
    return _caruserDAOInstance ??= _$CarUserDAO(database, changeListener);
  }
}

class _$UserDAO extends UserDAO {
  _$UserDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'lastName': item.lastName,
                  'phoneNumber': item.phoneNumber,
                  'email': item.email,
                  'birthday': item.birthday,
                  'adresse': item.adresse
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  @override
  Future<List<User>> retrieveUsers() async {
    return _queryAdapter.queryList('SELECT * FROM User',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            lastName: row['lastName'] as String,
            phoneNumber: row['phoneNumber'] as String,
            email: row['email'] as String,
            birthday: row['birthday'] as String,
            adresse: row['adresse'] as String));
  }

  @override
  Future<User?> deleteUser(int id) async {
    return _queryAdapter.query('DELETE FROM User WHERE id = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            lastName: row['lastName'] as String,
            phoneNumber: row['phoneNumber'] as String,
            email: row['email'] as String,
            birthday: row['birthday'] as String,
            adresse: row['adresse'] as String),
        arguments: [id]);
  }

  @override
  Future<User?> deleteAllUsers() async {
    return _queryAdapter.query('DELETE * FROM User',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            lastName: row['lastName'] as String,
            phoneNumber: row['phoneNumber'] as String,
            email: row['email'] as String,
            birthday: row['birthday'] as String,
            adresse: row['adresse'] as String));
  }

  @override
  Future<User?> retrieveUser(int id) async {
    return _queryAdapter.query('SELECT * FROM User WHERE id = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            lastName: row['lastName'] as String,
            phoneNumber: row['phoneNumber'] as String,
            email: row['email'] as String,
            birthday: row['birthday'] as String,
            adresse: row['adresse'] as String),
        arguments: [id]);
  }

  @override
  Future<List<User>> finduserByusername(String lastName) async {
    return _queryAdapter.queryList('SELECT * FROM User WHERE lastName = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            lastName: row['lastName'] as String,
            phoneNumber: row['phoneNumber'] as String,
            email: row['email'] as String,
            birthday: row['birthday'] as String,
            adresse: row['adresse'] as String),
        arguments: [lastName]);
  }

  @override
  Future<int> inserUser(User user) {
    return _userInsertionAdapter.insertAndReturnId(
        user, OnConflictStrategy.abort);
  }
}

class _$CarDAO extends CarDAO {
  _$CarDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _carInsertionAdapter = InsertionAdapter(
            database,
            'Car',
            (Car item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'model': item.model,
                  'year': item.year,
                  'license_Plate': item.license_Plate,
                  'initial_mileage': item.initial_mileage
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Car> _carInsertionAdapter;

  @override
  Future<List<Car>> retrieveCars() async {
    return _queryAdapter.queryList('SELECT * FROM Car',
        mapper: (Map<String, Object?> row) => Car(
            id: row['id'] as int?,
            name: row['name'] as String,
            model: row['model'] as String,
            year: row['year'] as String,
            license_Plate: row['license_Plate'] as String,
            initial_mileage: row['initial_mileage'] as String));
  }

  @override
  Future<Car?> deleteCar(int id) async {
    return _queryAdapter.query('DELETE FROM Car WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Car(
            id: row['id'] as int?,
            name: row['name'] as String,
            model: row['model'] as String,
            year: row['year'] as String,
            license_Plate: row['license_Plate'] as String,
            initial_mileage: row['initial_mileage'] as String),
        arguments: [id]);
  }

  @override
  Future<Car?> deleteAllCars() async {
    return _queryAdapter.query('DELETE * FROM Car',
        mapper: (Map<String, Object?> row) => Car(
            id: row['id'] as int?,
            name: row['name'] as String,
            model: row['model'] as String,
            year: row['year'] as String,
            license_Plate: row['license_Plate'] as String,
            initial_mileage: row['initial_mileage'] as String));
  }

  @override
  Future<Car?> retrieveCar(int id) async {
    return _queryAdapter.query('SELECT * FROM Car WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Car(
            id: row['id'] as int?,
            name: row['name'] as String,
            model: row['model'] as String,
            year: row['year'] as String,
            license_Plate: row['license_Plate'] as String,
            initial_mileage: row['initial_mileage'] as String),
        arguments: [id]);
  }

  @override
  Future<int> insertCar(Car car) {
    return _carInsertionAdapter.insertAndReturnId(
        car, OnConflictStrategy.abort);
  }
}

class _$ObdDAO extends ObdDAO {
  _$ObdDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _oBDInsertionAdapter = InsertionAdapter(
            database,
            'OBD',
            (OBD item) => <String, Object?>{
                  'id': item.id,
                  'speed': item.speed,
                  'rpm': item.rpm,
                  'CoolantTemperature': item.CoolantTemperature,
                  'ModuleVoltage': item.ModuleVoltage,
                  'date_debut': item.date_debut,
                  'date_fin': item.date_fin,
                  'car_id': item.car_id
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<OBD> _oBDInsertionAdapter;

  @override
  Future<List<OBD>> retrieveAllOBD() async {
    return _queryAdapter.queryList('SELECT * FROM OBD',
        mapper: (Map<String, Object?> row) => OBD(
            id: row['id'] as int?,
            date_debut: row['date_debut'] as String,
            date_fin: row['date_fin'] as String,
            car_id: row['car_id'] as int,
            speed: row['speed'] as String,
            rpm: row['rpm'] as String,
            CoolantTemperature: row['CoolantTemperature'] as String,
            ModuleVoltage: row['ModuleVoltage'] as String));
  }

  @override
  Future<OBD?> deleteOBD(int id) async {
    return _queryAdapter.query('DELETE * FROM OBD WHERE id = ?1',
        mapper: (Map<String, Object?> row) => OBD(
            id: row['id'] as int?,
            date_debut: row['date_debut'] as String,
            date_fin: row['date_fin'] as String,
            car_id: row['car_id'] as int,
            speed: row['speed'] as String,
            rpm: row['rpm'] as String,
            CoolantTemperature: row['CoolantTemperature'] as String,
            ModuleVoltage: row['ModuleVoltage'] as String),
        arguments: [id]);
  }

  @override
  Future<OBD?> deleteAllOBD() async {
    return _queryAdapter.query('DELETE * FROM OBD',
        mapper: (Map<String, Object?> row) => OBD(
            id: row['id'] as int?,
            date_debut: row['date_debut'] as String,
            date_fin: row['date_fin'] as String,
            car_id: row['car_id'] as int,
            speed: row['speed'] as String,
            rpm: row['rpm'] as String,
            CoolantTemperature: row['CoolantTemperature'] as String,
            ModuleVoltage: row['ModuleVoltage'] as String));
  }

  @override
  Future<OBD?> retrieveOBD(int id) async {
    return _queryAdapter.query('SELECT * FROM OBD WHERE id = ?1',
        mapper: (Map<String, Object?> row) => OBD(
            id: row['id'] as int?,
            date_debut: row['date_debut'] as String,
            date_fin: row['date_fin'] as String,
            car_id: row['car_id'] as int,
            speed: row['speed'] as String,
            rpm: row['rpm'] as String,
            CoolantTemperature: row['CoolantTemperature'] as String,
            ModuleVoltage: row['ModuleVoltage'] as String),
        arguments: [id]);
  }

  @override
  Future<List<int>> insertOBD(List<OBD> obd) {
    return _oBDInsertionAdapter.insertListAndReturnIds(
        obd, OnConflictStrategy.abort);
  }
}

class _$CarUserDAO extends CarUserDAO {
  _$CarUserDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _caruserInsertionAdapter = InsertionAdapter(
            database,
            'CarUser',
            (caruser item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.id_user,
                  'car_id': item.id_car
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<caruser> _caruserInsertionAdapter;

  @override
  Future<List<caruser>> retrieveAllcarsusers() async {
    return _queryAdapter.queryList('SELECT * FROM CarUser',
        mapper: (Map<String, Object?> row) => caruser(
            id: row['id'] as int?,
            id_user: row['user_id'] as int,
            id_car: row['car_id'] as int));
  }

  @override
  Future<List<caruser>> findcaridbyuserid(int id) async {
    return _queryAdapter.queryList('SELECT * FROM CarUser WHERE user_id = ?1',
        mapper: (Map<String, Object?> row) => caruser(
            id: row['id'] as int?,
            id_user: row['user_id'] as int,
            id_car: row['car_id'] as int),
        arguments: [id]);
  }

  @override
  Future<List<int>> insertCaruser(List<caruser> caruser) {
    return _caruserInsertionAdapter.insertListAndReturnIds(
        caruser, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _usercarConverter = usercarConverter();
