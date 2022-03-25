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


  @Query('SELECT * FROM User WHERE lastName = :lastName')
  Future<List<User>> finduserByusername(String lastName);


}
