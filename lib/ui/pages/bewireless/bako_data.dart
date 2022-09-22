import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class bakodata with ChangeNotifier{
  Map<String, dynamic> _map = {};

  bool _error = false;
  String _errormessage='';
  Map<String, dynamic> get map => _map ;
  bool get error => _error ;
  String get errormessage => _errormessage;


Future<void> get fetchData async {
  final response = await get(Uri.parse("http://192.168.4.1/CAN"),);
  // 0x1026105A
  // http://192.168.4.1/CAN

  if(response.statusCode == 200){
    try {
     _map = jsonDecode(response.body);
     _error =false;
    }catch (e){

      _error = true;
      _errormessage= e.toString();
      _map = {};

    }
    notifyListeners();

  }
  else{
    _error = true;
    _errormessage= "it could be you not connect to wifi";
    _map = {};
  }
  notifyListeners();
}

void initialValues(){
  _error = false;
  _errormessage= "";
  _map = {};

  notifyListeners();

}





}