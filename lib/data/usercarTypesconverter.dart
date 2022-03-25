import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:mini_project/data/CarEntity.dart';

class usercarConverter extends TypeConverter<List<Car>, String> {
  @override
  List<Car> decode(String databaseValue) {
    List list = jsonDecode(databaseValue);
    List<Car> cars = [];
    list.map((value) {
      cars.add(Car.fromJson(value));
    });
    return cars;
  }
  @override
  String encode(List<Car> value) {
    List jsonData =
    // ignore: non_constant_identifier_names
    value.map((Car) => Car.toMap()).toList();

    String v = json.encode(jsonData);
    return v;
  }
}
