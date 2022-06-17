import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class realtime_db extends StatefulWidget {
  const realtime_db({Key? key}) : super(key: key);

  @override
  State<realtime_db> createState() => _realtime_dbState();
}

class _realtime_dbState extends State<realtime_db> {
  //late DatabaseReference _dbref;
  String databasejson ="";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_dbref = FirebaseDatabase.instance.reference();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(  " database - " + databasejson),
              ),
              TextButton(    onPressed: () {
                _createDB();
              }, child: const Text(" create DB")),
              TextButton(onPressed: () {
                _realdb_once();
              }, child: const Text(" read value")),
              TextButton(onPressed: () {
                _readdb_onechild();
              }, child: const Text(" read once child")),
              TextButton(onPressed: () {
                _updatevalue();
              }, child: const Text(" update value")),

              //   _updatevalue_count()
              TextButton(onPressed: () {
                _delete();
              }, child: const Text(" delete value")),
              TextButton(onPressed: () {
                chauffeurSetup();
              }, child: const Text(" add chauffeur ")),
            ],
          ),
        ),
      ),
    );
  }

/*_createDB() {
  _dbref.child("profile").set(" Amine ghribi");
  _dbref.child("jobprofile").set({'website': "www.blueappsoftware.com", "website2": "www.dripcoding.com"});
  _dbref.child("phone").set("94574896");

}*/
  _createDB() {
   // _dbref.child("jobprofile").child("website").push().set({'profile':'Aminos' , 'phone':'94574896'});
    //_dbref.child("jobprofile").set({'website': "www.blueappsoftware.com", "website2": "www.dripcoding.com"});
    //_dbref.child("phone").set("94574896");

  }
_realdb_once() {
  /**_dbref.once().then((DataSnapshot dataSnapshot) {
    print(" read once - " + dataSnapshot.value.toString());
    setState(() {
      databasejson = dataSnapshot.value.toString();
    });
  });*/
}

  _readdb_onechild() {
  /*  _dbref.child("jobprofile/website/N02hGzx4PYn65CR-99G/94574896").once().then((
        DataSnapshot dataSnapshot) {
      print(" read once - " + dataSnapshot.value.toString());
      setState(() {
        databasejson = dataSnapshot.value.toString();
      });
    });*/
    debugPrint("jobprofile-website-profile "+ databasejson);
  }
  _delete() {
    //_dbref.child("profile").remove();
  }

  Future<void> chauffeurSetup() async {
    CollectionReference chauffeurs = FirebaseFirestore.instance.collection('Chauffeurs');
    chauffeurs.add({ "name" : "amine" ,  "surName" : "ghribi", "phoneNumber" : "94574896" ,
        "email" : "aghribi011@gmail.com" , "birthday" :"9/11" , "adresse": "gabes", "username" :"amine", "password" : "123456" });
  }

  _updatevalue() {
  //  _dbref.child("jobprofile").update({ "website2": "www.dripcoding.com2"});
  }
}