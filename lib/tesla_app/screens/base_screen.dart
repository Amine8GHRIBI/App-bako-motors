import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mini_project/tesla_app/screens/diagnostic_screen.dart';
import 'package:mini_project/ui/pages/Dashboard.dart';
import 'package:mini_project/ui/pages/DashbordScreen.dart';
import 'package:mini_project/ui/pages/slider_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mini_project/ui/pages/wifi_home.dart';
import 'package:unicons/unicons.dart';
import 'dart:developer' as developer;

import '../../DataBase/user_database.dart';
import '../../data/CarEntity.dart';
import '../../data/OBDParametres.dart';
import '../../data/userEntity.dart';
import '../../ui/pages/Meteo-page.dart';
import '../../ui/pages/OBD.dart';
import '../../ui/pages/StatsScreen.dart';
import '../../ui/pages/connexion_obd.dart';
import '../../ui/pages/meteo_page/GetStarted.dart';
import '../../ui/pages/setting_screen.dart';
import '../configs/colors.dart';
import 'home_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class BaseScreen extends StatefulWidget {

   UserDatabase database;
   User user;
   Car car ;
   BaseScreen({Key? key , required this.database , required this.user , required this.car }) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> with SingleTickerProviderStateMixin {

  final GlobalKey<FormState> _homeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _statkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dashkey = GlobalKey<FormState>();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  final Connectivity _connectivity = Connectivity();

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;




  int _selectedIndex = 0;
  late final TabController _tabController;
  final int _tabLength = 4;

  @override
  void initState() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    super.initState();
   // initConnectivity();
    useradd();
    retrieveOBDBydate(this.widget.database , formatted);

   // _connectivitySubscription =
      //  _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
      setState(()  {
    });

  }

  Future<void> initConnectivity() async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
      } else if (connectivityResult == ConnectivityResult.wifi) {
        this.chauffeurSetup();
        debugPrint("data send ...");
      }
  }

  Future<void> chauffeurSetup() async {
    CollectionReference chauffeurs = FirebaseFirestore.instance.collection('Chauffeurs');
    chauffeurs.add({ "name" : "amineca" ,  "surName" : "ghribi", "phoneNumber" : "94574896" ,
      "email" : "aghribi011@gmail.com" , "birthday" :"9/11" , "adresse": "gabes", "username" :"amine", "password" : "123456" });
  }


  Future<void> useradd() async {
   /* String name ="";
    final querySnapshot = await FirebaseFirestore.instance.collection("Users")
        .doc("firstuser")
        .collection("Chauffeurs").where('Name', isEqualTo: this.widget.user.name.toString()).get();
    for (var doc in querySnapshot.docs) {
      // Getting data directly
      name = doc.get('name');
    }

    if(name != "") {
      FirebaseFirestore.instance.collection("Users")
          .doc("firstuser")
          .collection("Chauffeurs").where('Name', isEqualTo: this.widget.user.name.toString())
          .then((value) {
        print(value.id);
        FirebaseFirestore.instance
            .collection("Users")
            .doc("firstuser")
            .collection("Chauffeurs")
            .doc(value.id)
            .collection("Cars")
            .add({"petName": "blacky", "petType": "dog", "petAge": 1});

        return ;
    });
          }
    else{*/
    debugPrint("use mail " + this.widget.user.email.toString());
    FirebaseFirestore.instance.collection("Users")
        .doc("firstuser")
        .collection("Chauffeurs").doc(this.widget.user.email.toString())
        .set({ "userName": this.widget.user.username.toString(),
               "Name": this.widget.user.name.toString(),
               "SurName":this.widget.user.surName.toString(),
               "email" : this.widget.user.email.toString(),
               "phoneNumber" : this.widget.user.phoneNumber.toString()
            ,  "adresse" : this.widget.user.adresse.toString()
             , "birthday" : this.widget.user.birthday.toString()}).then((value) {

      FirebaseFirestore.instance
          .collection("Users")
          .doc("firstuser")
          .collection("Chauffeurs")
          .doc(this.widget.user.email.toString())
          .collection("Cars")
          .doc(this.widget.car.license_Plate.toString())
          .set({"Name": this.widget.car.name.toString(),
                "modele": this.widget.car.model.toString(),
               "Year": this.widget.car.year.toString(),
                "intial mileage" : this.widget.car.initial_mileage.toString(), "license_plat" : this.widget.car.license_Plate.toString()})
          .then((value) {
            for(OBD obd in obdsbydate) {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc("firstuser")
                  .collection("Chauffeurs")
                  .doc(this.widget.user.email.toString())
                  .collection("Cars")
                  .doc(this.widget.car.license_Plate.toString())
                  .collection("OBD")
                  .add({ "vitesse": obd.speed.toString(), "RPM" : obd.rpm.toString(),
                         "kilometrage": obd.DistanceMILOn.toString(),
                         "temperature" : obd.CoolantTemperature.toString(),
                         "date" : obd.time.toString()
                  });
            }
          });
             return ;
             });
  }

  List<OBD> obdsbydate = [];
  Future<List<OBD>> retrieveOBDBydate(UserDatabase db , String date) async {
    obdsbydate =await db.obdDAO.retrieveLastOBDByDate(date, this.widget.car.id!.toInt());
    setState(() {});
    return obds;

  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  List<OBD> obds = [];
  List<OBD> newobd = [];

  Future<List<OBD>> retrieveOBD(UserDatabase db) async {
    obds =await db.obdDAO.retrieveAllOBD();
    //debugPrint("obd diagno " + obds.length.toString());
    setState(() {});
    return obds;
  }

  Future<List<OBD>> retrieveOBDbycar(UserDatabase db) async {
    obds =await db.obdDAO.retrieveOBDbycar(1);
    debugPrint("obd diagno by car" + obds.length.toString());
    setState(() {});
    return obds;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Widget> _pages = [

      HomeScreen(database: widget.database ,user: this.widget.user, car : this.widget.car ,key: GlobalKey(),),
      DashboardScreen(database: this.widget.database ,user: this.widget.user ,key: _dashkey),
      //dashboard(database: this.widget.database ,user: this.widget.user,key: GlobalKey()),
      obd(),
      StatsScreen(database: this.widget.database ,user: this.widget.user,key: GlobalKey()),

    ];
    navigateTo(int index) {
      setState(() {
      _pages.removeAt(0);
      _pages.insert(0,  HomeScreen(database: this.widget.database,user: this.widget.user, car : this.widget.car , key: GlobalKey()));
        _selectedIndex = index;
      });
    }
   /* navigateTo(int index)  {


      Future.delayed(Duration.zero,() {
      setState(() async {
        _pages.removeAt(0);
        _pages.insert(0,  HomeScreen(database: this.widget.database ,user: this.widget.user ,key: GlobalKey()));
       // obds =await this.widget.database.obdDAO.retrieveAllOBD();
        //debugPrint("obdss" + obds.length.toString());
        _tabController.animateTo(index);
        _selectedIndex = index;
      });
      });

    }
*/
    Widget _bottomAppBarIcon({required int index, required IconData icon}) {

      return IconButton(
        onPressed: () {
          navigateTo(index);
        },
        icon: Icon(
          icon,
          color: _selectedIndex == index ? theme.primaryColor : null,
        ),
        iconSize: 25,
      );
    }

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: SafeArea(
          child: Container(
            height: 70,
            color: theme.bottomAppBarColor,
            child: Material(
              type: MaterialType.transparency,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  _bottomAppBarIcon(index: 0, icon: Icons.home_rounded),
                  _bottomAppBarIcon(index: 1, icon: Icons.directions_car),
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          bottom: 20,
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.bottomAppBarColor),
                              child: IconButton(
                                  iconSize: 60,
                                  onPressed: () {
                                    Get.to( connexion(theme: theme,),arguments: {"database" : this.widget.database , "user" : this.widget.user, });
                                  },
                                  icon: Icon(
                                    Icons.power_settings_new_rounded,
                                    color: theme.iconTheme.color,
                                  ))),
                        ),
                      ],
                    ),
                  ),
                  _bottomAppBarIcon(index: 2, icon: Icons.map),
                  _bottomAppBarIcon(index: 3, icon: IconData(0xebef, fontFamily: 'MaterialIcons')),

                ],
              ),
            ),
          ),
        ),
      ),
      body:
     /* NotificationListener(
      onNotification: (scrollNotification) {
      if (scrollNotification is ScrollEndNotification) _onTabChanged();
      return false;
      },
    child:*/ Container(
        decoration: BoxDecoration(
          gradient: kBackGroundGradient
        ),
        /*child: TabBarView(
          controller: _tabController,
          children:
            _pages
            /*HomeScreen(database: this.widget.database ,user: this.widget.user), DashboardScreen(database: this.widget.database ,user: this.widget.user),
            dashboard(database: this.widget.database ,user: this.widget.user),
            SettingsScreen(),*/

        ),*/
      child: IndexedStack(
        index: _selectedIndex,
        children: _pages
      ),
      ),

    );
  }

  void _onTabChanged() {
    switch (_tabController.index) {
      case 0:
      // handle 0 position
        break;
      case 1:
      // handle 1 position
        break;
    }
    setState(() {});
  }
}
