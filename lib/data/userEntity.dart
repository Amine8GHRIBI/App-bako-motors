import 'dart:ffi';


import 'package:floor/floor.dart';
import 'package:mini_project/data/CarEntity.dart';
/*@Entity(
  tableName: 'user',
  foreignKeys: [
    ForeignKey(
      childColumns: ['car_id'],
      parentColumns: ['id'],
      entity: Car,
    )
  ],
)*/
@entity
class User {

  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String birthday;
  final String adresse;
  //@ColumnInfo(name: 'car_id')
   //final List<Car> cars;


  User({ this.id,
  //  required this.cars,
    required this.name,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.birthday,
    required this.adresse,
    });

  static listFromJson(List<Map<String, dynamic>> list) {
    List<User> users = [];
    for (var value in list) {
      users.add(User.fromJson(value));
    }
    return users;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'lastName': this.lastName,
      'phoneNumber': this.phoneNumber,
      'email': this.email,
      'birthday': this.birthday,
      'adresse': this.adresse,
     // 'cars': [this.cars],
    };
  }

  static fromJson(Map<String, dynamic> map){
    return User(
      name: map["name"] ,
      phoneNumber: map["phoneNumber"] ,
      lastName : map["lastName"] ,
      //cars : Car.listFromJson(map['cars']),
      email: map["email"] ,
      adresse: map["adresse"] ,
      birthday: map["birthday"] ,
    );}
}
