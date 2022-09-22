import 'dart:async';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_project/ui/pages/DashbordScreen.dart';
import 'package:provider/provider.dart';

import '../../DataBase/user_database.dart';
import '../../data/CarEntity.dart';
import '../../data/OBDParametres.dart';
import '../../data/userEntity.dart';
import '../../ui/pages/OBD.dart';
import '../../ui/pages/StatsScreen.dart';
import '../../ui/pages/bewireless/bako_data.dart';
import '../../ui/pages/connexion_obd.dart';
import '../../ui/pages/maps/_LocationTrackerBlogState.dart';
import '../../ui/pages/notfoundgpps.dart';
import '../configs/colors.dart';
import 'home_screen.dart';
import 'package:get/get.dart';


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
  Timer? timer;
  int _selectedIndex = 0;
  late final TabController _tabController;
  final int _tabLength = 4;

  @override
  void initState() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    super.initState();
    //initConnectivity();
    timer = Timer.periodic(const Duration(milliseconds: 1), (Timer t) => context.read<bakodata>().fetchData );
   // retrieveOBDBydate(widget.database , formatted);

   // _connectivitySubscription =
      //  _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
      setState(()  {
    });

  }

  Future<void> initConnectivity() async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
      } else if (connectivityResult == ConnectivityResult.wifi) {
        await useradd();
        debugPrint("data send ...");
      }
  }


  Future<void> deletedatafromlocal() async {}

  Future<void> useradd() async {
// timer = Timer.periodic(Duration(seconds: 1), (Timer t) => context.read<ObdReader>().increment());
  /*  debugPrint("use mail " + widget.user.email.toString());
    FirebaseFirestore.instance.collection("Users")
        .doc("firstuser")
        .collection("Chauffeurs").doc(widget.user.email.toString())
        .set({ "userName": widget.user.username.toString(),
               "Name": widget.user.name.toString(),
               "SurName":widget.user.surName.toString(),
               "email" : widget.user.email.toString(),
               "phoneNumber" : widget.user.phoneNumber.toString()
            ,  "adresse" : widget.user.adresse.toString()
             , "birthday" : widget.user.birthday.toString()}).then((value) {

      FirebaseFirestore.instance
          .collection("Users")
          .doc("firstuser")
          .collection("Chauffeurs")
          .doc(widget.user.email.toString())
          .collection("Cars")
          .doc(widget.car.license_Plate.toString())
          .set({"Name": widget.car.name.toString(),
                "modele": widget.car.model.toString(),
                "Year": widget.car.year.toString(),
                "intial mileage" : widget.car.initial_mileage.toString(), "license_plat" : widget.car.license_Plate.toString()})
          .then((value) {
            for(OBD obd in obdsbydate) {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc("firstuser")
                  .collection("Chauffeurs")
                  .doc(widget.user.email.toString())
                  .collection("Cars")
                  .doc(widget.car.license_Plate.toString())
                  .collection("OBD")
                  .add({ "vitesse": obd.speed.toString(),
                         "RPM" : obd.rpm.toString(),
                         "kilometrage": obd.DistanceMILOn.toString(),
                         "temperature" : obd.CoolantTemperature.toString(),
                         "date" : obd.date.toString(),
                         "time" : obd.time.toString()
                  }); }
          });
             return ;
             });*/
  }

  List<OBD> obdsbydate = [];
  Future<List<OBD>> retrieveOBDBydate(UserDatabase db , String date) async {
    obdsbydate =await db.obdDAO.retrieveLastOBDByDate(date, widget.car.id!.toInt());
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
      HomeScreen(database: widget.database ,user: widget.user, car : widget.car ,key: GlobalKey()),
      DashboardScreen(database: widget.database ,user: widget.user ,car : widget.car, key: _dashkey),
      //dashboard(database: this.widget.database ,user: this.widget.user,key: GlobalKey()),
      locationtracker(),
      //LocalNotifications(),
      StatsScreen(database: widget.database ,user: widget.user, car : widget.car , key: GlobalKey()),
    ];

    navigateTo(int index) {
      setState(() {
      _pages.removeAt(0);
      _pages.insert(0,  StatsScreen(database: widget.database,user: widget.user, car : widget.car , key: GlobalKey()));
        _selectedIndex = index;
      });
    }

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
                                    Get.to( connexion(theme: theme,database : widget.database , user: widget.user,));
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
                  _bottomAppBarIcon(index: 3, icon: const IconData(0xebef, fontFamily: 'MaterialIcons')),

                ],
              ),
            ),
          ),
        ),
      ),
      body:
      Container(
        decoration: const BoxDecoration(
          gradient: kBackGroundGradient
        ),
      child:
     IndexedStack(
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
