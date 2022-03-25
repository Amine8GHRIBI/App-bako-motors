
import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:mini_project/data/userEntity.dart';

class caruserConverter extends TypeConverter<List<User>, String> {
  @override
  List<User> decode(String databaseValue) {
    List list = jsonDecode(databaseValue);
    List<User> users = [];
    list.map((value) {
      users.add(User.fromJson(value));
    });
    return users;
  }

  @override
  String encode(List<User> value) {
    List jsonData =
    // ignore: non_constant_identifier_names
    value.map((User) => User.toMap()).toList();

    String v = jsonEncode(jsonData);
    return v;
  }
}
