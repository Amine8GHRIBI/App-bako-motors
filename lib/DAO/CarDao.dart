

import 'package:floor/floor.dart';

import '../data/CarEntity.dart';

@dao
abstract class CarDAO{

  @insert
  Future<int> insertCar(Car car);

  @Query('SELECT * FROM Car')
  Future<List<Car>> retrieveCars();

  @Query('DELETE FROM Car WHERE id = :id')
  Future<Car?> deleteCar(int id);

  @Query('DELETE * FROM Car')
  Future<Car?> deleteAllCars();

  @Query('SELECT * FROM Car WHERE id = :id')
  Future<Car?> retrieveCar(int id);

}