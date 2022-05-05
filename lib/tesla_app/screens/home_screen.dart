import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../DataBase/user_database.dart';
import '../../data/OBDParametres.dart';
import '../../data/userEntity.dart';
import '../../ui/Constants.dart';
import '../../ui/pages/TransitionRouteObserver.dart';
import '../../ui/widget/drawer/drawer.dart';
import '../../ui/widget/login_widget/fadeIn.dart';
import '../configs/colors.dart';

class HomeScreen extends StatefulWidget {

   UserDatabase database;
   User user;
   HomeScreen({Key? key,required this.database, required this.user} ) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin, TransitionRouteAware {
  //late UserDatabase database;
  //late User user;
  bool _showDrawer = false;
  String batt ='' ;
  String newbatt='';

  List<OBD> obds = [];
  List<OBD> obdsbydate = [];

  List<OBD> newobd = [];
  int kilometrage = 0;
  String conduite ="";

  int conduiteheure =0;
  int conduiteminute=0;

  Future<List<OBD>> retrieveOBD(UserDatabase db) async {
    obds =await db.obdDAO.retrieveAllOBD();
    debugPrint("obd  your " + obds.last.speed.toString());
    setState(() {});
    return obds;
  }

  Future<List<OBD>> retrieveOBDBydate(UserDatabase db , String date) async {

    obdsbydate =await db.obdDAO.retrieveLastOBDByDate(date);

    conduiteheure = (int.parse(obds.last.time.substring(0,2))) - (int.parse(obds.first.time.substring(0,2)));
    conduiteminute = int.parse(obds.last.time.substring(3,5)) - int.parse(obds.first.time.substring(3,5));
    conduite = conduiteheure.toString() + ':' + conduiteminute.toString();

    for(OBD o in obdsbydate){
      kilometrage += int.parse(o.DistanceMILOn);
    }
    debugPrint("obds by date  " + obdsbydate.length.toString());
    setState(() {});
    return obds;

  }




  Future<String> Mybattery(UserDatabase db) async {
    newobd = await retrieveOBD(db);
    late String speedtest;
    if(newobd.last != null ) {
      speedtest = newobd.last.CoolantTemperature;
    }else{
      speedtest = "no element in base ";
    }
    //OBD speedtestt = newobd.firstWhere((element) => element.speed.isNotEmpty,
      //  orElse: () => 'No matching color found');

    if (double. parse(speedtest) >= 12.6){
       batt = "100%";
    }else
      if (12.5 <= (double. parse( speedtest.toString())) && (double. parse( speedtest.toString())) < 12.6){
      batt = "85%";
    }else
      if (12.4 <=  (double. parse( speedtest.toString())) &&  (double. parse(speedtest.toString())) < 12.5 ){
      batt = "75%";
    }else

    if (12.2 <=  (double. parse( speedtest.toString())) &&  (double. parse( speedtest.toString())) < 12.4 ){
      batt = "65%";
    }else
    if (12.1 <=  (double. parse( speedtest.toString())) &&  (double. parse( speedtest.toString())) <  12.2 ){
      batt = "50%";
    }else
    if (12.0 <=  (double. parse( speedtest.toString())) && (double. parse( speedtest.toString())) <  12.1 ){
      batt = "35%";
    }else
    if (11.9 <=  (double. parse( speedtest.toString()))&& (double. parse( speedtest.toString())) <  12.0 ){
      batt = "25%";
    }else
    if (11.8 <= (double. parse( speedtest.toString())) &&  (double. parse(speedtest.toString())) < 11.9 ){
      batt = "15%";
    }else
    if ( double. parse( speedtest.toString()) <= 11.8 ){
      batt = "0%";
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
      await this.chauffeurSetup();
      debugPrint("data send ...");
    }
    setState(()  {},);
  }
  
  Future<void> chauffeurSetup() async {
    CollectionReference chauffeurs = FirebaseFirestore.instance.collection('Chauffeurs');
    chauffeurs.add({ "name" : "aminos" ,  "surName" : "ghribi", "phoneNumber" : "94574896" ,
      "email" : "aghribi011@gmail.com" , "birthday" :"9/11" , "adresse": "gabes", "username" :"amine", "password" : "123456" });
  }

  @override
  void initState()  {

    super.initState();

    Future.delayed(Duration.zero,() async {
      //await this.initConnectivity();
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(now);
      print(formatted);
      await Mybattery(this.widget.database);
      await retrieveOBDBydate(this.widget.database, formatted);

      debugPrint("time " + obds.last.time.substring(0,2).toString());
      debugPrint("time " + obds.first.time.substring(0,2).toString());


      setState(() {
        },);
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
                'assets/image/bako.png',
                filterQuality: FilterQuality.high,
                height: 30,
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
    final theme = Theme.of(context);
    Size size = MediaQuery.of(context).size; //check the size of device
    ThemeData themeData = Theme.of(context);
    int currIndex;
    return WillPopScope(

        onWillPop: () => _goToLogin(context),
        child: Scaffold(
          appBar: _buildAppBar(theme),
          body:  Container(
          padding: const EdgeInsets.all(10),
            child : SingleChildScrollView(
            child: Stack(
            children: <Widget>[

            Column(
             children: <Widget>[

              /*Material(
                type: MaterialType
                    .transparency, // to visible splash / ripple effect. the parent's decoration color is covering ripple effect
                child: Row(
                  children: [
                    IconButton(
                        iconSize: 50,
                        splashRadius: 25,
                        onPressed: () {},
                        icon: Icon(
                          Icons.menu_rounded,
                          color: kPrimaryColor,
                        )),
                    Spacer(),
                    Stack(
                      children: [
                        IconButton(
                            iconSize: 50,
                            splashRadius: 25,
                            onPressed: () {},
                            icon: FittedBox(
                                child: Icon(Icons.account_circle_rounded))),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                color: kPrimaryColor, shape: BoxShape.circle),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),*/
              Text(
                'Your Bako',
                style: TextStyle(fontSize: 25,color: theme.textTheme.headline1?.color, fontWeight: FontWeight.bold),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 35),
                child: Text(
                  'MODEL X',
                  style: TextStyle(fontSize: 35,color: theme.textTheme.headline1?.color, fontWeight: FontWeight.w200),
                ),
              ),

              Image.asset('lib/tesla_app/images/homepage_tesla.png'),

              new CircularPercentIndicator(
                radius: 200.0,
                lineWidth: 25.0,
                animation: true,
                percent: 0.8,
                center: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        batt.toString(),
                        style:
                        theme.textTheme.headline5,
                      ),
                      Text(
                        'Charged',
                        style: TextStyle(fontWeight: FontWeight.bold , color: theme.textTheme.headline1?.color),
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
                  SvgPicture.asset('lib/tesla_app/images/lighting.svg'),
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Text('Charging.. 14 mins remaining', style: TextStyle(color: theme.textTheme.headline1?.color , fontWeight: FontWeight.w200)
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
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: 104,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('kilometrage',
                                  style: TextStyle(fontWeight: FontWeight.bold , color: theme.textTheme.headline1?.color)),
                              Text('Today' , style: TextStyle(color: theme.textTheme.headline1?.color)),

                              SizedBox(height: 10),
                              Center(
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text:  kilometrage.toString(),
                                        style: theme.textTheme.headline2),
                                    WidgetSpan(
                                      child: Transform.translate(
                                        offset: Offset(0, -12),
                                        child: Text('km',
                                            style: theme.textTheme.bodyText2,
                                      ),
                                    ),
                                    ),    ]),

                                ),
                              )
                            ],

                          ),
                        ),

                      ),

                    ),

                    SizedBox(
                      width: 20,
                    ),


                    Card(
                      color: theme.bottomAppBarColor,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: 104,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Conduite',
                                  style: TextStyle(fontWeight: FontWeight.bold , color: theme.textTheme.headline1?.color) ),
                              Text('Today', style: TextStyle(color: theme.textTheme.headline1?.color)),
                              SizedBox(height: 10),
                          SizedBox(height: 10),
                          Center(
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: conduite.toString(),
                                    style: theme.textTheme.headline2),
                                WidgetSpan(
                                  child: Transform.translate(
                                    offset: Offset(0, -12),
                                    child: Text('h/min',
                                      style: theme.textTheme.bodyText2,
                                    ),
                                  ),
                                ),    ]),
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
              Container(
                width: 195.0,
              height: 600.0,
              child:
              DrawerWidget(
                closeFunction: showDrawer,),
            )),
          ]

          ),

    ),

        ),

        ),



    );
  }
}
