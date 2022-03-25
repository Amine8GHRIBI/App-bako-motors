import 'dart:async';
import 'package:floor/floor.dart';
import 'package:mini_project/DAO/caruserDAO.dart';
import 'package:mini_project/data/CarUserEntity.dart';
import 'package:mini_project/data/usercarTypesconverter.dart';
import '../DAO/CarDao.dart';
import '../DAO/ObdDao.dart';
import '../data/CarEntity.dart';
import '../data/OBDParametres.dart';
import '../data/userEntity.dart';
import '../DAO/UserDao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


part 'user_database.g.dart'; // the generated code will be there

@TypeConverters([usercarConverter])
@Database(version: 1, entities: [User,Car,OBD,caruser])
abstract class UserDatabase extends FloorDatabase {
  UserDAO get userDAO;
  CarDAO get carDAO;
  ObdDAO get obdDAO;
  CarUserDAO get caruserDAO;
}
