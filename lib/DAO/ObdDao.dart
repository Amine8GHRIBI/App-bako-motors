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

  @Query('SELECT * FROM OBD WHERE id = :id')
  Future<OBD?> retrieveOBD(int id);

  @Query('SELECT * FROM (SELECT * FROM OBD ORDER BY id DESC LIMIT 7) Var1 ORDER BY id ASC')
  Future<List<OBD>> retrieveLastOBD();

  @Query('SELECT * FROM OBD WHERE date = :date')
  Future<List<OBD>> retrieveLastOBDByDate(String date);






}