import 'package:floor/floor.dart';

import '../data/OBDParametres.dart';
@dao
abstract class ObdDAO{

  @insert
  Future<List<int>> insertOBD(List<OBD> obd);

  @Query('SELECT * FROM OBD')
  Future<List<OBD>> retrieveAllOBD();

  @Query('DELETE * FROM OBD WHERE id = :id')
  Future<OBD?> deleteOBD(int id);

  @Query('DELETE * FROM OBD')
  Future<OBD?> deleteAllOBD();

  @Query('SELECT * FROM OBD WHERE car_id = :id')
  Future<List<OBD>> retrieveOBDbycar(int id);

  @Query('DELETE * FROM OBD WHERE car_id = :id')
  Future<OBD?> deleteOBDbycar(int id);


  @Query('SELECT * FROM (SELECT * FROM OBD ORDER BY id DESC LIMIT 7) Var1 ORDER BY id ASC WHERE id = :id')
  Future<List<OBD>> retrieveLastOBD(int id);

  @Query('SELECT * FROM OBD WHERE date = :date and car_id = :id' )
  Future<List<OBD>> retrieveLastOBDByDate(String date , int id);

}