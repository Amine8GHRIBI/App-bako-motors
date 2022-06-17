import 'package:floor/floor.dart';

@entity
class Car {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String model;
  final String year;
  final String license_Plate;
  final String initial_mileage;

  //@ColumnInfo(name: 'user_id' )
  //final int id_user;
  //final List<OBD> obds;
  Car({
    this.id,
   // required this.id_user,
    required this.name,
    required this.model,
    required this.year,
    required this.license_Plate,
    required this.initial_mileage,
    //required this.obds
  });

  static listFromJson(List<Map<String, dynamic>> list) {
    List<Car> cars = [];
    for (var value in list) {
      cars.add(Car.fromJson(value));
    }
    return cars;
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'model': model,
      'year': initial_mileage,
      'license_Plate': license_Plate,
      'initial_mileage': initial_mileage,

    };
  }

  static fromJson(Map<String, dynamic> parsedJson){
    return Car(
        name: parsedJson["name"] ,
        model: parsedJson["model"] ,
        year : parsedJson["year"] ,
        license_Plate: parsedJson["license_Plate"] ,
        initial_mileage: parsedJson["initial_mileage"],
      //  id_user: parsedJson["id_user"],
        //obds: parsedJson["obds"],
        //users : User.listFromJson(parsedJson['users'])
    );
  }
}