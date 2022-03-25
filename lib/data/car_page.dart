
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/DataBase/user_database.dart';

import '../ui/pages/user-page.dart';
import 'CarEntity.dart';
import 'CarUserEntity.dart';

class carPage extends StatefulWidget {
  const carPage({Key? key}) : super(key: key);

  @override
  State<carPage> createState() => _carPageState();
}

class _carPageState extends State<carPage> {

  late UserDatabase database;

/*
  Future<List<int>> addcar(database db ) async {
    //, String phoneNumber , String birthday , String email,String  adresse
    Car firstcar = Car(name : "bako", model :"elec", year : "2020",license_Plate: "200", initial_mileage : "100");
    debugPrint("car add " + firstcar.name );

    //User firstUser = User(name: "amine ", lastName: "ghribi", phoneNumber : "94574896" , email : "agh@gmail.com ", birthday :"19595", adresse :"gabes ");
    return await db.carDAO.insertCar([firstcar]);
  }
*/

  Future<int> addcar(UserDatabase db ) async {
    //, String phoneNumber , String birthday , String email,String  adresse
    Car firstcar = Car(name : "bako", model :"elec", year : "2020",license_Plate: "200", initial_mileage : "100");
    int carid = await db.carDAO.insertCar(firstcar);
    debugPrint("car add " + carid.toString());

    //User firstUser = User(name: "amine ", lastName: "ghribi", phoneNumber : "94574896" , email : "agh@gmail.com ", birthday :"19595", adresse :"gabes ");
    return await db.carDAO.insertCar(firstcar);
  }

  Future<List<int>> addusercar(UserDatabase db ) async {
    //, String phoneNumber , String birthday , String email,String  adresse
    caruser firstcaruser = caruser(id_car: 1 , id_user: 1);
    debugPrint("car add " + firstcaruser.id_car.toString());

    //User firstUser = User(name: "amine ", lastName: "ghribi", phoneNumber : "94574896" , email : "agh@gmail.com ", birthday :"19595", adresse :"gabes ");
    return await db.caruserDAO.insertCaruser([firstcaruser]);
  }

  Future<List<Car>> retrievCars() async {
    return await this.database.carDAO.retrieveCars();
  }


  Future<List<caruser>> retrievCarsusers() async {
    return await this.database.caruserDAO.retrieveAllcarsusers();
  }

  @override
  void initState() {
    super.initState();
    $FloorUserDatabase
        .databaseBuilder('user_database.db')
        .build()
        .then((value) async {
      this.database = value;
      //await this.addcar(this.database);
      //await this.addusercar(this.database);

      // await this.addUsers(this.database);
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("list cars"),

      ),
      body: FutureBuilder(
        //future: retrievCars(),
        future: retrievCars(),
        builder: (BuildContext context, AsyncSnapshot<List<Car>> snapshot) {

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.delete_forever),

                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    /*await this
                        .CarDatabase
                        .usDAO
                        .deleteUser(snapshot.data![index].id!);*/
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child:  InkWell(
                    child: Card(

                      child: ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        title: Text(snapshot.data![index].name.toString()),
                        subtitle: Text(snapshot.data![index].initial_mileage.toString()),

                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context , '/user',arguments: {"user" : snapshot.data![index]});
                      // ignore: avoid_function_literals_in_foreach_calls
                      debugPrint("user data " + snapshot.data![index].toString());
                    },

                  ),

                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

/*Widget buildetailButton() => ButtonWidget(
    text: 'Upgrade To PRO',
    onClicked: () {Navigator.pushNamed(context , '/user',arguments: {"staff" : user});},
  );
*/
}