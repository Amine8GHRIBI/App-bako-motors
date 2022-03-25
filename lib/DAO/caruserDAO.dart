import 'package:floor/floor.dart';
import 'package:mini_project/data/CarUserEntity.dart';

@dao
abstract class CarUserDAO{


  @insert
  Future<List<int>> insertCaruser(List<caruser> caruser);

  @Query('SELECT * FROM CarUser')
  Future<List<caruser>> retrieveAllcarsusers();
  
  @Query('SELECT * FROM CarUser WHERE user_id = :id')
  Future<List<caruser>> findcaridbyuserid(int id);



  /*
  @Query('SELECT user_id FROM CarUser WHERE car_id = :id')
  Future<List<int?>> finduseridbycarid(int id);
*/

}