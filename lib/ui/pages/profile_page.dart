import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/data/CarEntity.dart';

import '../../DataBase/user_database.dart';
import '../../data/CarUserEntity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/userEntity.dart';



class profile_page extends StatefulWidget {
  const profile_page({Key? key}) : super(key: key);

  @override
  State<profile_page> createState() => _profile_pageState();
}

class _profile_pageState extends State<profile_page> {
  late UserDatabase database;
  late User? user ;
  String name='';
  String model ='';
  String year ='';
  String license_Plate='';
  String initial_mileage='';

  Future<List<caruser>> retrievCarsusers() async {
    return await this.database.caruserDAO.retrieveAllcarsusers();
  }

  Future<User?> retrieveUserbyid(int id) async {
    user = await this.database.userDAO.retrieveUser(id);
    return user;
  }
  Future<int> addcar(UserDatabase db ,String name , String model ,String year ,String license_Plate ,String initial_mileage ) async {
    //, String phoneNumber , String birthday , String email,String  adresse
    Car firstcar = Car(name : name, model : model, year :year ,license_Plate: license_Plate, initial_mileage : initial_mileage );
     int id_car =  await db.carDAO.insertCar(firstcar);

     debugPrint("car add " + firstcar.name );
    List<int> carusers = await this.addusercar(db, id_car, 1);
    //User firstUser = User(name: "amine ", lastName: "ghribi", phoneNumber : "94574896" , email : "agh@gmail.com ", birthday :"19595", adresse :"gabes ");
    return id_car;
  }

  Future<List<int>> addusercar(UserDatabase db , int idcar , int iduser  ) async {
    //, String phoneNumber , String birthday , String email,String  adresse
    caruser firstcaruser = caruser(id_car: idcar , id_user: iduser);
    debugPrint("car add " + firstcaruser.id_car.toString());

    //User firstUser = User(name: "amine ", lastName: "ghribi", phoneNumber : "94574896" , email : "agh@gmail.com ", birthday :"19595", adresse :"gabes ");
    return await db.caruserDAO.insertCaruser([firstcaruser]);
  }

  Future<List<Car>> retrievCarsByuser(int id ) async {
    List<caruser> carsuser = await this.database.caruserDAO.findcaridbyuserid(id);
    List<int> idcars = [] ;
    List<Car> cars =[];
    for (caruser cu in carsuser){
      debugPrint("idcaruser" + cu.id_car.toString());
      idcars.add(cu.id_car);
    }
    for (int id in idcars){
      Car? cr = await this.database.carDAO.retrieveCar(id);
      cars.add(cr!);
    }

    return cars;
  }


  @override
  void initState() {
    super.initState();
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
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 4,
                decoration: BoxDecoration(
                    color: Color(0xff5a348b),
                    gradient: LinearGradient(
                        colors: [Color(0xff8d70fe), Color(0xff2da9ef)],
                        begin: Alignment.centerRight,
                        end: Alignment(-1.0, -1.0)
                    )
                ),
                child: _myHeaderContent(),
              ),
            ),
            Positioned( top: 200.0,
            left: 10.0,

            child: Container(
              color: Colors.white,
                  width: 320.0,
                 height: MediaQuery
        .of(context)
        .size
        .height / 2.0,

    child:FutureBuilder(
    future: retrieveUserbyid(1),
    builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
      return Dismissible(
          key: Key(snapshot.data!.id!.toString()),
          background: _myHiddenContainer(
              Colors.red
          ),
      child :  _myListContainer(
    snapshot.data!.name, snapshot.data!.lastName,
    snapshot.data!.phoneNumber, Colors.red
    ),);

    },),),),
            Positioned(

              
              top: 350.0,
              left: 10.0,

              child: Container(
                color: Colors.white,
                width: 320.0,
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 2.0,
                child:FutureBuilder(
                  future : retrievCarsByuser(1),
                  builder: (BuildContext context, AsyncSnapshot<List<Car>> snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: Key(snapshot.data![index].id!.toString()),
                        background: _myHiddenContainer(
                          Colors.black
                        ),
                        child: _myListContainer(
                            snapshot.data![index].name, snapshot.data![index].model,
                            snapshot.data![index].year, Colors.red
                        ),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text("Delete")));
                            if (snapshot.data!.contains(snapshot.data!.removeAt(index))) {
                              setState(() {
                                snapshot.data!.remove(snapshot.data!.removeAt(index));
                              });
                            }
                          } else {
                            if (direction == DismissDirection.endToStart) {
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text("Archive"))
                              );
                              // Archive functionality
                            }
                          }
                        },
                      );
                    }
                );},)
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                final taskval = TextEditingController();
                final subval = TextEditingController();
                final tasktime = TextEditingController();

                Color taskcolor;

                return AlertDialog(
                  title: Text("New car"),
                  content: Container(
                    height: 250.0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            onChanged: (value) {
                             name = value.toString().trim();
                           },
                            controller: taskval,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "car name",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Container(
                          child: TextField(
                            onChanged: (value) {
                              model = value.toString().trim();
                            },
                            controller: taskval,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "car modele",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Container(
                          child: TextField(
                            onChanged: (value) {
                              year = value.toString().trim();
                            },
                            controller: subval,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "car year",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Container(
                          child: TextField(
                            onChanged: (value) {
                              initial_mileage = value.toString().trim();
                            },
                            controller: tasktime,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "initial_mileage"
                              ,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),

                  Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new GestureDetector(
                                onTap: () {
                                  taskcolor = Colors.purple;
                                },
                                child: Container(
                                  width: 25.0,
                                  height: 25.0,
                                  color: Colors.purple,
                                ),
                              ),
                              new GestureDetector(
                                onTap: () {
                                  taskcolor = Colors.amber;
                                },
                                child: Container(
                                  width: 25.0,
                                  height: 25.0,
                                  color: Colors.amber,
                                ),
                              ),
                              new GestureDetector(
                                onTap: () {
                                  taskcolor = Colors.blue;
                                },
                                child: Container(
                                  width: 25.0,
                                  height: 25.0,
                                  color: Colors.blue,
                                ),
                              ),
                              new GestureDetector(
                                onTap: () {
                                  taskcolor = Colors.green;
                                },
                                child: Container(
                                  width: 25.0,
                                  height: 25.0,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: TextField(
                            onChanged: (value) {
                              license_Plate = value.toString().trim();
                            },
                            controller: tasktime,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "license_Plate"
                                ,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  actions: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)
                      ),
                      color: Color(0xff2da9ef),
                      child: Text("Add", style: new TextStyle(
                          color: Colors.white
                      ),),
                      onPressed: () {
                        this.addcar(database ,name, model,year,license_Plate, initial_mileage);

                        setState(() {

                          /*tasks.add(new Task(
                              taskval.text, subval.text, tasktime.text,
                              taskcolor));*/
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              }
          );
        },
        backgroundColor: Color(0xff2da9ef),
        foregroundColor: Color(0xffffffff),
        tooltip: "Increment",
        child: new Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff2da9ef),
        shape: CircularNotchedRectangle(

        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.stickyNote),
              color: Colors.white,
              onPressed: () {

              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.search),
              color: Colors.white,
              onPressed: () {

              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _myListContainer(String taskname, String subtask, String taskTime,
      Color taskColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80.0,
        child: Material(
          color: Colors.white,
          elevation: 14.0,
          shadowColor: Color(0x802196F3),
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  height: 80.0,
                  width: 10.0,
                  color: taskColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            child: Text(taskname, style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            child: Text(subtask, style: TextStyle(
                                fontSize: 18.0, color: Colors.blueAccent)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(taskTime, style: TextStyle(
                          fontSize: 18.0, color: Colors.black45)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _myHiddenContainer(Color taskColor) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      color: taskColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                icon: Icon(FontAwesomeIcons.solidTrashAlt),
                color: Colors.white,
                onPressed: () {
                  setState(() {

                  });
                }),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Icon(FontAwesomeIcons.archive),
                color: Colors.white,
                onPressed: () {
                  setState(() {

                  });
                }),
          ),
        ],
      ),
    );
  }

  Widget _myHeaderContent() {
    return Align(
      child: ListTile(
        leading: Icon(Icons.account_box, size: 60,),
        title: Text(
            "Profile", style: TextStyle(fontSize: 24.0, color: Colors.white)),
        subtitle: Text(
            "", style: TextStyle(fontSize: 14.0, color: Colors.white)),
      ),
    );
  }
}