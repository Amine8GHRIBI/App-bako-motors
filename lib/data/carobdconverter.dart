import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:mini_project/data/OBDParametres.dart';

class carobdConverter extends TypeConverter<List<OBD>, String> {
  @override
  List<OBD> decode(String databaseValue) {
    List list = json.decode(databaseValue);
    List<OBD> obds = [];
    list.map((value) {
      obds.add(OBD.fromJson(value));
    });
    return obds;
  }

  @override
  String encode(List<OBD> value) {
    String v = json.encode(value);
    return v;
  }
}