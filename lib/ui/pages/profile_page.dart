import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mini_project/data/CarEntity.dart';
import 'package:mini_project/ui/pages/slider_page.dart';

import '../../DataBase/user_database.dart';
import '../../data/CarUserEntity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/userEntity.dart';



class profile_page extends StatefulWidget {


  profile_page({Key? key}) : super(key: key);

  @override
  State<profile_page> createState() => _profile_pageState();
}

class _profile_pageState extends State<profile_page> {
  late UserDatabase database;
  late User? user ;
  late ThemeData theme;
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
  }

  @override
  Widget build(BuildContext context) {

    final routes =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>;
    database = routes["database"];
    user =routes["user"];
    theme = routes["theme"];

    return Scaffold(
      appBar:
      AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: theme.iconTheme.color),
        ),
        backgroundColor: theme.bottomAppBarColor,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
      ),
      backgroundColor: theme.cardTheme.color,
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
                    image : DecorationImage(
                      image : new ExactAssetImage('assets/image/dash.jpg'),
                        fit: BoxFit.cover,
                      // height: 30,
                    ),
                   color: Color(0xff5a348b),
                    gradient: LinearGradient(
                        colors: [Color(0xff8d70fe), Color(0xff2da9ef)],
                        begin: Alignment.centerRight,
                        end: Alignment(-1.0, -1.0)
                    )
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect( // Clip it cleanly.
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          color: Colors.grey.withOpacity(0.1),
                          alignment: Alignment.center,
                          child: _myHeaderContent(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 225.0,
              left: 10.0,

            child: Container(
              padding:  EdgeInsets.all(2.3),
              color: theme.cardColor,
                  width: 340.0,
                 height: MediaQuery
        .of(context)
        .size
        .height / 0.5,

    child:FutureBuilder(
    future: retrieveUserbyid(1),

    builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
      return Dismissible(

          key: Key(snapshot.data!.id!.toString()),
          background: _myHiddenContainer(
              Colors.red
          ),
      child : Column(

          children: <Widget>[
          Text( 'Complete profile ',
            textAlign: TextAlign.right,

            style: GoogleFonts.poppins(
            color:    theme.textTheme.headline1?.color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),),
              //flex: 1, // takes 30% of available width
               _myListContainer(snapshot.data!.name, snapshot.data!.surName,
                  snapshot.data!.phoneNumber, theme.cardTheme.color),

    ]),);

    },),),),
            Positioned(
              top: 340.0,
              left: 20.0,
              child: Container(
                  padding:  EdgeInsets.all(2.3),
                  color: theme.cardColor,

                width: 320.0,
                height: MediaQuery.of(context).size.height / 1,
                child:FutureBuilder(
                  future : retrievCarsByuser(1),
                  builder: (BuildContext context, AsyncSnapshot<List<Car>> snapshot) {
                  return ListView.builder(

                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(

                        key: Key(snapshot.data![index].id!.toString()),
                        background: _myHiddenContainer(Colors.red),
                        child :
                        _myListContainer(
                            snapshot.data![index].name, snapshot.data![index].license_Plate,
                            snapshot.data![index].year,  theme.cardTheme.color
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
                final modelval = TextEditingController();
                final yearval = TextEditingController();
                final mileageval = TextEditingController();
                final platval = TextEditingController();
                final subval = TextEditingController();
                final tasktime = TextEditingController();

                Color taskcolor;

                return AlertDialog(
                  backgroundColor: theme.cardTheme.color,
                  title: Text("New car"),
                  content: Container(
                    height: 280.0,
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
                              hintStyle: TextStyle(color: theme.textTheme.headline1?.color),
                            ),
                          ),
                        ),
                        Container(
                          child: TextField(
                            onChanged: (value) {
                              model = value.toString().trim();
                            },
                            controller:  modelval,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "car modele",
                              hintStyle: TextStyle(color: theme.textTheme.headline1?.color),
                            ),
                          ),
                        ),
                        Container(
                          child: TextField(
                            onChanged: (value) {
                              year = value.toString().trim();
                            },
                            controller: yearval,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "car year",
                              hintStyle: TextStyle(color: theme.textTheme.headline1?.color),
                            ),
                          ),
                        ),
                        Container(
                          child: TextField(
                            onChanged: (value) {
                              initial_mileage = value.toString().trim();
                            },
                            controller: mileageval,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "initial_mileage"
                              ,
                              hintStyle: TextStyle(color: theme.textTheme.headline1?.color),
                            ),
                          ),
                        ),

                        Container(
                          child: TextField(
                            onChanged: (value) {
                              license_Plate = value.toString().trim();
                            },
                            controller: platval,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "license_Plate"
                                ,
                              hintStyle: TextStyle(color:theme.textTheme.headline1?.color),
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
                      color: theme.bottomAppBarColor,
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
        backgroundColor:  theme.primaryColor,
        foregroundColor: Color(0xffffffff),
        tooltip: "Increment",
        child: new Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: theme.primaryColor,
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

  Widget _myListContainer(String taskname, String subtask, String taskTime, Color? taskColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),

      child: Container(

        height: 80.0,
        child: Material(

          color: taskColor,
          elevation: 14.0,
          shadowColor: theme.primaryColor,

          child: Container(
            child: Row(
              children: <Widget>[
            InkWell(

            child : Container(
                  height: 80.0,
                  width: 10.0,
                  color: taskColor,
                ),

            ),
          InkWell(
           /* onTap: () {
              Get.to( slider_connexion(database: this.database, use: this.user,theme:theme,));
            },*/
        child :          Expanded(
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
                                color: theme.textTheme.headline1?.color,
                                fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,

                          child: Container(
                            child: Text(subtask, style: TextStyle(
                                fontSize: 18.0, color:theme.textTheme.headline1?.color)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(taskTime, style: TextStyle(
                          fontSize: 18.0, color: theme.textTheme.headline1?.color)
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

      height: MediaQuery.of(context).size.height,
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
        leading: Icon(Icons.account_box, size: 75, color:  theme.primaryColor),
        title: Text(
            "Profile", style: TextStyle(fontSize: 28.0, color: theme.primaryColor)),
        subtitle: Text(
            "Amine Ghribi", style: TextStyle(fontSize: 24.0, color:  theme.primaryColor)),
      ),
    );
  }
}