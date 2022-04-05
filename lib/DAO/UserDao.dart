import 'package:floor/floor.dart';
import '../data/userEntity.dart';

@dao
abstract class UserDAO {

  @insert
  Future<int> inserUser(User user);

  @Query('SELECT * FROM User')
  Future<List<User>> retrieveUsers();

  @Query('DELETE FROM User WHERE id = :id')
  Future<User?> deleteUser(int id);

  @Query('DELETE * FROM User')
  Future<User?> deleteAllUsers();

  @Query('SELECT * FROM User WHERE id = :id')
  Future<User?> retrieveUser(int id);


  @Query('SELECT * FROM User WHERE email = :email')
  Future<List<User>> finduserByemail(String email);

  @Query('SELECT * FROM User WHERE phoneNumber = :phoneNumber')
  Future<List<User>> finduserByphone(String phoneNumber);

  @Query('SELECT * FROM User WHERE password = :password')
  Future<List<User>> finduserBypassword(String password);





}
