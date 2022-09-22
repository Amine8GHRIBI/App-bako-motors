//import'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../DataBase/user_database.dart';
import '../../data/CarEntity.dart';
import '../../data/OBDParametres.dart';
import '../../data/userEntity.dart';
import '../../ui/Constants.dart';
import '../../ui/pages/TransitionRouteObserver.dart';
import '../../ui/pages/bewireless/bako_data.dart';
import '../../ui/widget/drawer/drawer.dart';
import '../../ui/widget/login_widget/fadeIn.dart';


class HomeScreen extends StatefulWidget {

   UserDatabase database;
   User user;
   Car car;
   ThemeData? theme;
   //final Map<String,dynamic> map;
   HomeScreen({Key? key,required this.database, required this.user , required this.car , this.theme} ) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin, TransitionRouteAware {
  //late UserDatabase database;
  //late User user;
  bool _showDrawer = false;
  double batt = 0.0 ;
  String newbatt='';

  List<OBD> obds = [];
  List<OBD> obdsbydate = [];

  List<OBD> newobd = [];
  double kilometrage = 0;
  String conduite ="00:00";

  int conduiteheure =0;
  int conduiteminute=0;

  Future<List<OBD>> retrieveOBD(UserDatabase db) async {
    obds =await db.obdDAO.retrieveAllOBD();
    debugPrint("obd  your " + obds.last.speed.toString());
    setState(() {});
    return obds;
  }

  Future<List<OBD>> retrieveOBDBydate(UserDatabase db , String date) async {

    //obdsbydate =await db.obdDAO.retrieveLastOBDByDate(date, 1);
    obds =await db.obdDAO.retrieveAllOBD();
    DateTime lastdate =  DateTime.parse(obds.last.date);
    DateTime firstdate = DateTime.parse(obds.first.date);
    //date1.difference(date2).inHours;
    conduiteheure =lastdate.difference(firstdate).inHours;
    conduiteminute = lastdate.difference(firstdate).inMinutes;
    //conduiteheure = (int.parse(obds.last.time.substring(0,2))) - (int.parse(obds.first.time.substring(0,2)));
    //conduiteminute = int.parse(obds.last.time.substring(3,5)) - int.parse(obds.first.time.substring(3,5));
    conduite = conduiteheure.toString() + ':' + conduiteminute.toString();

    for (OBD obd in obds) {
      if (int.tryParse(obd.DistanceMILOn) != null) {
        kilometrage += int.parse(obd.DistanceMILOn)
        ;
      }
    }

    debugPrint("obds by date  " + obdsbydate.length.toString());
    setState(() {});
    return obds;

  }

  double getbatt = 12.1;

  Future<double> Mybattery(UserDatabase db) async {
    if (this.widget.car.name != "Aucun")  {
      if (getbatt >= 12.6) {
        batt = 100;
      } else if (12.5 <= (getbatt) && (getbatt) < 12.6) {
        batt = 85;
      } else if (12.4 <= (getbatt) && (getbatt) < 12.5) {
        batt = 75;
      } else

      if (12.2 <= (getbatt) && (getbatt) < 12.4) {
        batt = 65;
      } else if (12.1 <= (getbatt) && (getbatt) < 12.2) {
        batt = 50;
      } else if (12.0 <= (getbatt) && (getbatt) < 12.1) {
        batt = 35;
      } else if (11.9 <= (getbatt) && (getbatt) < 12.0) {
        batt = 25;
      } else if (11.8 <= (getbatt) && (getbatt) < 11.9) {
        batt = 15;
      } else if (getbatt <= 11.8) {
        batt = 0;
      }
    }
    setState(() {});
    return batt;
  }

  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/log')
    // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  final routeObserver = TransitionRouteObserver<PageRoute?>();
  static const headerAniInterval = Interval(.1, .3, curve: Curves.easeOut);
  late Animation<double> _headerScaleAnimation;
  AnimationController? _loadingController;

  Future<void> initConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
    } else if (connectivityResult == ConnectivityResult.wifi) {
      await chauffeurSetup();
      debugPrint("data send ...");
    }
    setState(()  {},);
  }

  Future<void> chauffeurSetup() async {
 /*   CollectionReference chauffeurs = FirebaseFirestore.instance.collection('Chauffeurs');
    chauffeurs.add({ "name" : "aminos" ,  "surName" : "ghribi", "phoneNumber" : "94574896" ,
      "email" : "aghribi011@gmail.com" , "birthday" :"9/11" , "adresse": "gabes", "username" :"amine", "password" : "123456" });*/
  }
  Timer? timer;
  @override
  void initState()  {
    super.initState();
    Future.delayed(Duration.zero,() async {
      //await this.initConnectivity();
      //timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => context.read<bakodata>().fetchData );
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(now);
      print(formatted);
      //await Mybattery(widget.database);
     // await retrieveOBDBydate(widget.database, now.toString());
      setState(() {},);
    });

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _headerScaleAnimation =
        Tween<double>(begin: .6, end: 1).animate(CurvedAnimation(
          parent: _loadingController!,
          curve: headerAniInterval,
        ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context) as PageRoute<dynamic>?);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _loadingController!.dispose();
    super.dispose();
  }

  void showDrawer() {
    print('tapped on show drawer!');
    setState(() {
      _showDrawer = !_showDrawer;
    });
  }

  @override
  void didPushAfterTransition() => _loadingController!.forward();
  AppBar _buildAppBar(ThemeData theme) {

    final menuBtn = IconButton(
        color:  theme.iconTheme.color,// parm color
        icon: const Icon(FontAwesomeIcons.bars),
        onPressed: showDrawer
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color:  theme.iconTheme.color,
      onPressed: () => _goToLogin(context),
    );

    final title = Center(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Hero(
              tag: Constants.logoTag,
              child: Image.asset(
                'assets/image/bakoappbar.png',
                filterQuality: FilterQuality.high,
                height: 38,

              ),
            ),
          ),

          // const SizedBox(width: 20),
        ],
      ),
    );

    return AppBar(
      leading: FadeIn(
        controller: _loadingController,
        offset: .3,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.startToEnd,
        child: menuBtn,
      ),
      actions: <Widget>[
        FadeIn(
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
          child: signOutBtn,
        ),
      ],
      title: title,
      backgroundColor: theme.bottomAppBarColor,
      elevation: 0,
      // toolbarTextStyle: TextStle(),
      // textTheme: theme.accentTextTheme,
      // iconTheme: theme.accentIconTheme,
    );
  }

  @override
  Widget build(BuildContext context) {

     double batterie;
     double kilometrage ;
     double tripmetre;
     double controler_temp;
     double trip;
     double battpercent;
    if(context.watch<bakodata>().map['ID_10261022'].toString() == 'null' ){
      batterie = 0.0;
      kilometrage =0.0;
      tripmetre = 0.0;
      controler_temp= 0.0;
      trip=0.0;
      battpercent=0.0;
    }
    else
    {
      kilometrage = (double.parse((int.parse(context.watch<bakodata>().map['ID_1026105A'].toString().substring(1,7),radix: 16)).toString()));
      tripmetre = (double.parse((int.parse((context.watch<bakodata>().map['ID_1026105A'].toString().substring(8,10) + context.watch<bakodata>().map['ID_1026105A'].toString().substring(6,8)),radix: 16)).toString())) ;
      batterie = (double.parse((int.parse((context.watch<bakodata>().map['ID_10261022'].toString().substring(10,12) + context.watch<bakodata>().map['ID_10261022'].toString().substring(8,10)),radix: 16)*0.1).toString()));
      controler_temp =(double.parse((int.parse(context.watch<bakodata>().map['ID_10261023'].toString().substring(0,2),radix: 16)).toString()));
      trip =(double.parse((int.parse((context.watch<bakodata>().map['ID_1026105A'].toString().substring(8,10) + context.watch<bakodata>().map['ID_1026105A'].toString().substring(6,8) ),radix: 16) / 60 ).toString()));
      if (batterie >= 54) {
        battpercent = 100;
      } else if (53.88 <= (batterie) && (batterie) < 54){
        battpercent = 99;
      } else if (53.76 <= (batterie) && (batterie) < 53.88){
        battpercent = 98;
      } else if (53.64 <= (batterie) && (batterie) < 53.76){
        battpercent = 97;
      } else if (53.52 <= (batterie) && (batterie) < 53.64){
        battpercent = 96;
      } else if (53.4 <= (batterie) && (batterie) < 53.52){
        battpercent = 95;
      } else if (53.28 <= (batterie) && (batterie) < 53.4){
        battpercent = 94;
      } else if (53.16 <= (batterie) && (batterie) < 53.28){
        battpercent = 93;
      } else if (53.04 <= (batterie) && (batterie) < 53.16){
        battpercent = 92;
      }else if (52.92 <= (batterie) && (batterie) < 53.04){
        battpercent = 91;
      }else if (52.8 <= (batterie) && (batterie) < 52.92){
        battpercent = 90;
      }else if (52.68 <= (batterie) && (batterie) < 52.8){
        battpercent = 89;
      }else if (52.56 <= (batterie) && (batterie) < 52.68){
        battpercent = 88;
      }else if (52.44 <= (batterie) && (batterie) < 52.56){
        battpercent = 87;
      }else if (52.32 <= (batterie) && (batterie) < 52.44){
        battpercent = 86;
      }else if (52.2 <= (batterie) && (batterie) < 52.32){
        battpercent = 85;
      }
      else if (52.08 <= (batterie) && (batterie) < 52.2){
        battpercent = 84;
      }else if (51.96 <= (batterie) && (batterie) < 52.08){
        battpercent = 83;
      }else if (51.84 <= (batterie) && (batterie) < 51.96){
        battpercent = 82;
      }else if (51.72 <= (batterie) && (batterie) < 51.84){
        battpercent = 81;
      }else if (51.60 <= (batterie) && (batterie) < 51.72){
        battpercent = 80;
      }else if (51.72 <= (batterie) && (batterie) < 51.60){
        battpercent = 79;
      }else if (51.72 <= (batterie) && (batterie) < 51.60){
        battpercent = 79;
      }else if (51.72 <= (batterie) && (batterie) < 51.60){
        battpercent = 79;
      }else if (51.72 <= (batterie) && (batterie) < 51.72){
        battpercent = 79;
      }else if (51.72 <= (batterie) && (batterie) < 51.60){
        battpercent = 79;
      }else if (51.48 <= (batterie) && (batterie) < 51.60){
        battpercent = 79;
      }else if (51.36 <= (batterie) && (batterie) < 51.48){
        battpercent = 79;
      }else if (51.24 <= (batterie) && (batterie) < 51.36){
        battpercent = 79;
      }else if (51.12 <= (batterie) && (batterie) < 51.24){
        battpercent = 79;
      }else if (51.00 <= (batterie) && (batterie) < 51.12){
        battpercent = 79;
      }else if (50.88 <= (batterie) && (batterie) < 51.00){
        battpercent = 79;
      }else if (50.76 <= (batterie) && (batterie) < 50.88){
        battpercent = 79;
      }
      else if (50.64 <= (batterie) && (batterie) < 50.76){
        battpercent = 79;
      }else if (50.52 <= (batterie) && (batterie) <50.64){
        battpercent = 79;
      }else if (50.40 <= (batterie) && (batterie) < 50.52){
        battpercent = 79;
      }else if (50.28 <= (batterie) && (batterie) < 50.40){
        battpercent = 79;
      }else if (50.16 <= (batterie) && (batterie) < 50.28){
        battpercent = 79;
      }else if (50.04 <= (batterie) && (batterie) <50.16){
        battpercent = 79;
      }else if (49.92 <= (batterie) && (batterie) <50.04){
        battpercent = 79;
      }else if (49.80 <= (batterie) && (batterie) <49.92){
        battpercent = 79;
      }else if (49.68 <= (batterie) && (batterie) <49.80){
        battpercent = 79;
      }else if (49.56 <= (batterie) && (batterie) <49.68){
        battpercent = 79;
      }else if (49.44 <= (batterie) && (batterie) <49.56){
        battpercent = 79;
      }else if (49.32 <= (batterie) && (batterie) <49.44){
        battpercent = 79;
      }else if (49.2 <= (batterie) && (batterie) <49.32){
        battpercent = 79;
      }else if (48.96 <= (batterie) && (batterie) <49.2){
        battpercent = 79;
      }else if (48.84 <= (batterie) && (batterie) <48.96){
        battpercent = 79;
      }


      else if (48.72 <= (batterie) && (batterie) <48.84){
        battpercent = 79;
      }else if (48.60 <= (batterie) && (batterie) <48.72){
        battpercent = 79;
      }else if (48.48 <= (batterie) && (batterie) <48.60){
        battpercent = 79;
      }else if (48.36 <= (batterie) && (batterie) <48.48){
        battpercent = 79;
      }else if (48.24 <= (batterie) && (batterie) <48.36){
        battpercent = 79;
      }else if (48.12 <= (batterie) && (batterie) <48.24){
        battpercent = 79;
      }else if (48.00 <= (batterie) && (batterie) <48.12){
        battpercent = 79;
      }else if (47.88 <= (batterie) && (batterie) <48.00){
        battpercent = 79;
      }else if (47.76 <= (batterie) && (batterie) <47.88){
        battpercent = 79;
      }else if (47.64 <= (batterie) && (batterie) <47.76){
        battpercent = 79;
      }else if (47.52 <= (batterie) && (batterie) <47.64){
        battpercent = 79;
      }else if (47.40 <= (batterie) && (batterie) <47.64){
        battpercent = 79;
      }else if (47.28 <= (batterie) && (batterie) <47.40){
        battpercent = 79;
      }else if (47.16 <= (batterie) && (batterie) <47.28){
        battpercent = 79;
      }else if (47.04 <= (batterie) && (batterie) <47.16){
        battpercent = 79;
      }else if (46.92 <= (batterie) && (batterie) <47.04){
        battpercent = 79;
      }else if (46.8 <= (batterie) && (batterie) <46.92){
        battpercent = 79;
      }else if (46.68 <= (batterie) && (batterie) <46.8){
        battpercent = 79;
      }else if (46.56 <= (batterie) && (batterie) <46.68){
        battpercent = 79;
      }else if (46.44 <= (batterie) && (batterie) <46.56){
        battpercent = 79;
      }else if (46.32 <= (batterie) && (batterie) <46.44 ){
        battpercent = 79;
      }else if (46.2 <= (batterie) && (batterie) <46.32){
        battpercent = 79;
      }
      else {
        battpercent = 0.0;
      }
//
      /*else if (46.07 <= (batterie) && (batterie) <46.2){
        battpercent = 79;
      }else if (45.94 <= (batterie) && (batterie) < 46.07){
        battpercent = 79;
      }else if (46.2 <= (batterie) && (batterie) < 45.94){
        battpercent = 79;
      }else if (46.2 <= (batterie) && (batterie) <46.32){
        battpercent = 79;
      }else if (46.2 <= (batterie) && (batterie) <46.32){
        battpercent = 79;
      }else if (46.2 <= (batterie) && (batterie) <46.32){
        battpercent = 79;
      }else if (46.2 <= (batterie) && (batterie) <46.32){
        battpercent = 79;
      }else if (46.2 <= (batterie) && (batterie) <46.32){
        battpercent = 79;
      }else if (46.2 <= (batterie) && (batterie) <46.32){
        battpercent = 79;
      }else if (46.2 <= (batterie) && (batterie) <46.32){
        battpercent = 79;
      }
    }*/
    }

    final theme = Theme.of(context);
    Size size = MediaQuery.of(context).size; //check the size of device
    ThemeData themeData = Theme.of(context);
    int currIndex;
     return Consumer<bakodata>(
         builder: (context, value, child)
     {
       return WillPopScope(

         onWillPop: () => _goToLogin(context),
         child: Scaffold(
           appBar: _buildAppBar(theme),
           body: Container(
             padding: const EdgeInsets.all(10),
             child: SingleChildScrollView(
               child: Stack(
                   children: <Widget>[

                     Column(
                       children: <Widget>[

                         Text(
                           'Your Bako',
                           style: TextStyle(fontSize: 25,
                               color: theme.textTheme.headline1?.color,
                               fontWeight: FontWeight.bold),
                         ),
                         Padding(
                           padding: const EdgeInsets.only(top: 5, bottom: 6),
                           child: Text(
                             'MODEL '+ this.widget.car.model,
                             style: TextStyle(fontSize: 35,
                                 color: theme.textTheme.headline1?.color,
                                 fontWeight: FontWeight.w200),
                           ),
                         ),
                         Padding(
                           padding: const EdgeInsets.only(bottom: 15),
                           child: Image.asset('assets/newbako/home.png',
                               filterQuality: FilterQuality.high),
                         ),

                         CircularPercentIndicator(
                           radius: 200.0,
                           lineWidth: 25.0,
                           animation: true,
                           percent: (battpercent/100),
                           center: Center(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text(
                                   battpercent.toString()+ "%",
                                   style:
                                   theme.textTheme.headline5,
                                 ),
                                 Text(
                                   'Charged' ,
                                   style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                       color: theme.textTheme.headline1
                                           ?.color),
                                 )
                               ],
                             ),
                           ),
                           circularStrokeCap: CircularStrokeCap.round,
                           progressColor: theme.highlightColor,
                           backgroundColor: theme.dialogBackgroundColor,
                         ),

                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             SvgPicture.asset(
                                 'lib/tesla_app/images/lighting.svg'),
                             Padding(
                               padding: const EdgeInsets.only(right: 25),
                               child: Text('Charging.. 0 mins remaining',
                                   style: TextStyle(
                                       color: theme.textTheme.headline1
                                           ?.color,
                                       fontWeight: FontWeight.w200)
                               ),

                             )
                           ],
                         ),
                         Padding(
                           padding: const EdgeInsets.only(top: 20),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [

                               Card(
                                 color: theme.bottomAppBarColor,
                                 elevation: 10,
                                 shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(
                                         15.0)),
                                 child: Padding(
                                   padding: const EdgeInsets.all(20.0),
                                   child: SizedBox(
                                     width: 104,
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment
                                           .start,
                                       crossAxisAlignment: CrossAxisAlignment
                                           .start,
                                       children: [
                                         Text("Monitoring",
                                             style: TextStyle(
                                                 fontWeight: FontWeight.bold,
                                                 color: theme.textTheme
                                                     .headline1?.color)),
                                         Text('Today', style: TextStyle(
                                             color: theme.textTheme.headline1
                                                 ?.color)),

                                         const SizedBox(height: 10),
                                         Center(
                                           child: RichText(
                                             text: TextSpan(children: [
                                               TextSpan(
                                                   text:conduite.toString(),
                                                   style: theme.textTheme
                                                       .headline2),
                                               WidgetSpan(
                                                 child: Transform.translate(
                                                   offset: const Offset(
                                                       0, -12),
                                                   child: Text('h/min',
                                                     style: theme.textTheme
                                                         .bodyText2,
                                                   ),
                                                 ),
                                               ),
                                             ]),

                                           ),
                                         )
                                       ],

                                     ),
                                   ),

                                 ),

                               ),

                               const SizedBox(
                                 width: 20,
                               ),
                               Card(
                                 color: theme.bottomAppBarColor,
                                 elevation: 10,
                                 shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(
                                         15.0)),
                                 child: Padding(
                                   padding: const EdgeInsets.all(20.0),
                                   child: SizedBox(
                                     width: 104,
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment
                                           .start,
                                       crossAxisAlignment: CrossAxisAlignment
                                           .start,
                                       children: [
                                         Text('Tripmetre',
                                             style: TextStyle(
                                                 fontWeight: FontWeight.bold,
                                                 color: theme.textTheme
                                                     .headline1?.color)),
                                         Text('Today', style: TextStyle(
                                             color: theme.textTheme.headline1
                                                 ?.color)),
                                         const SizedBox(height: 10),
                                         const SizedBox(height: 10),
                                         Center(
                                           child: RichText(
                                             text: TextSpan(children: [
                                               TextSpan(
                                                   text: ((tripmetre)/10).toString(),
                                                   style: theme.textTheme
                                                       .headline2),
                                               WidgetSpan(
                                                 child: Transform.translate(
                                                   offset: const Offset(
                                                       0, -12),
                                                   child: Text('km',
                                                     style: theme.textTheme
                                                         .bodyText2,
                                                   ),
                                                 ),
                                               ),
                                             ]),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                               )
                             ],

                           ),

                         ),

                       ],

                     ),
                     if (_showDrawer)(
                         SizedBox(
                           width: 195.0,
                           height: 600.0,
                           child:
                           DrawerWidget(
                             closeFunction: showDrawer,),
                         )
                     ),
                   ]
               ),
             ),
           ),
         ),
       );
     }
     );
    }
  }

