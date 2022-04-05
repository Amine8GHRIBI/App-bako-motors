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
  final String username;
  final String name;
  final String surName;
  final String phoneNumber;
  final String email;
  final String password;
  final String birthday;
  final String adresse;
  //@ColumnInfo(name: 'car_id')
   //final List<Car> cars;


  User({ this.id,
  //  required this.cars,
    required this.name,
    required this.surName,
    required this.username,
    required this.password,
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
      'lastName': this.surName,
      'password' : this.password,
      'username' : this.username,
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
      surName : map["surName"] ,
      password : map["password"],
      username:  map["username"],
      //cars : Car.listFromJson(map['cars']),
      email: map["email"] ,
      adresse: map["adresse"] ,
      birthday: map["birthday"] ,
    );}
}
