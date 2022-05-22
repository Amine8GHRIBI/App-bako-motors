import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_sparkline/flutter_sparkline.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';
import '../widget/bottom_nav_bar.dart';


import '../../DataBase/user_database.dart';
import '../../data/OBDParametres.dart';
import '../../data/model.dart';
import '../../data/userEntity.dart';
import '../Constants.dart';
import '../widget/bottom_nav_item.dart';
import '../widget/drawer/drawer.dart';
import '../widget/login_widget/fadeIn.dart';
import 'TransitionRouteObserver.dart';
import 'OBD.dart';




class dashboard extends StatefulWidget {
  final UserDatabase database;
  final User user;

  const dashboard({Key? key,required this.database, required this.user}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

// ignore: camel_case_types
class _dashboardState extends State<dashboard> with SingleTickerProviderStateMixin, TransitionRouteAware{
  bool _showDrawer = false;
  List<OBD> obds = [];
  late UserDatabase database;
  late User user;
  List<OBD> newobd = [];


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



  Future<List<OBD>> retrieveOBD(UserDatabase db) async {
    obds =await this.widget.database.obdDAO.retrieveAllOBD();
    debugPrint("obd diagno " + obds.length.toString());
    setState(() {});

    return obds;
  }

  List<int> ob =[];
  Future<List<int>> addOBD(UserDatabase db) async {
    // int i = context.read<ObdReader>().obdData.length;
    //rMap<dynamic, dynamic> ii = context.watch<ObdReader>().obdData;

    OBD obddtat= OBD( speed: "180", rpm: "60", CoolantTemperature: "45", ModuleVoltage: "10", date : '22/04/2022', car_id:this.widget.user.id!, time: '22/04/2022', DistanceMILOn: '');
    List<int> obdsaved = await this.widget.database.obdDAO.insertOBD([obddtat]);

    for (int idsaved in obdsaved) {
      ob.add(idsaved);
    }
    // debugPrint("obd diagno " + ob.length.toString());

    return obdsaved;
  }


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() {
      //  retrieveOBD(this.widget.database);
      //debugPrint("obd diagno " + obds.last.speed.toString());
      setState(() async {
        database = this.widget.database;
        user = this.widget.user;
        newobd = await retrieveOBD(this.database);
        debugPrint("obd stat " + newobd.last.speed.toString());
      },);
    });
  /*  if(mounted) {
      Future.delayed(Duration.zero, () {
        setState(() {

          //retrievCarsusers(this.database);
         /// debugPrint("obd diagno " + obds.length.toString());
        },

        );
      },
      );
    }*/
    //context.read<ObdReader>().startOBD();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _headerScaleAnimation =
        Tween<double>(begin: .6, end: 1).animate(CurvedAnimation(
          parent: _loadingController!,
          curve: headerAniInterval,
        ));

  }

  Future<List<OBD>> retrievCarsusers(UserDatabase database) async {
    obds =await this.widget.database.obdDAO.retrieveAllOBD();
    return obds;
  }

  void showDrawer() {
    print('tapped on show drawer!');
    setState(() {
      _showDrawer = !_showDrawer;
    });
  }
  late bool start;

  @override
  void didPushAfterTransition() => _loadingController!.forward();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
/*
  AppBar _buildAppBar(ThemeData theme) {

    final menuBtn = IconButton(
        color:  HexColor("#175989"),// parm color
        icon: const Icon(FontAwesomeIcons.bars),
        onPressed: showDrawer
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color:  HexColor("#175989"),
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
      backgroundColor: theme.primaryColor.withOpacity(.1),
      elevation: 0,
      // toolbarTextStyle: TextStle(),
      // textTheme: theme.accentTextTheme,
      // iconTheme: theme.accentIconTheme,
    );
  }


  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];
  var data1 = [0.0,-2.0,3.5,-2.0,0.5,0.7,0.8,1.0,2.0,3.0,3.2];
/*
  List<CircularStackEntry> circularData = <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(700.0, Color(0xff4285F4), rankKey: 'Q1'),
        new CircularSegmentEntry(1000.0, Color(0xfff3af00), rankKey: 'Q2'),
        new CircularSegmentEntry(1800.0, Color(0xffec3337), rankKey: 'Q3'),
        new CircularSegmentEntry(1000.0, Color(0xff40b24b), rankKey: 'Q4'),
      ],
      rankKey: 'Quarterly Profits',
    ),
  ];*/

  Material myTextItems(String title, String subtitle){
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child:Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text(title,style:TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueAccent,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text(subtitle,style:TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Material myCircularItems(String title, String subtitle){
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child:Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text(title,style:TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueAccent,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text(subtitle,style:TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),

                 /* Padding(
                    padding:EdgeInsets.all(8.0),
                    child:AnimatedCircularChart(
                      size: const Size(100.0, 100.0),
                      initialChartData: circularData,
                      chartType: CircularChartType.Pie,
                    ),
                  ),*/

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Material mychart1Items(String title, String priceVal,String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(title, style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueAccent,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(priceVal, style: TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(subtitle, style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueGrey,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: new Sparkline(
                      data: data,
                      lineColor: Color(0xffff6101),
                      pointsMode: PointsMode.all,
                      pointSize: 8.0,
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Material mychart2Items(String title, String priceVal,String subtitle) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(title, style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueAccent,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(priceVal, style: TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(subtitle, style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blueGrey,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: new Sparkline(
                      data: data1,
                      fillMode: FillMode.below,
                      fillGradient: new LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.amber[800]!, Colors.amber[200]!],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

*/
  /*@override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    ThemeData themeData = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    final _dashboardState? state = context.findAncestorStateOfType<_dashboardState>();
   // while(true) {
      //context.read<ObdReader>().increment();


      return Scaffold(
        appBar: _buildAppBar(theme),
       // bottomNavigationBar: buildBottomNavBar(1,size ,themeData,context , this.widget.database , this.widget.user),

        body: Container(
          color: Color(0xffE5E5E5),

          child: StaggeredGridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                //child: battery(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: mychart1Items("kilometrage by hour","", "+12.9% of target"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: myCircularItems("Temps de conduit", context
                    .watch<ObdReader>().obdData['3'][1].toString()),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: myTextItems("Max speed", this.newobd.last.speed.toString()),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: myTextItems("Max kilometrage", ""),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: mychart2Items("Moy temperature", context.watch<ObdReader>().obdData['2'][1].toString(), "+19% of target"),
              ),
              if (_showDrawer)
                DrawerWidget(
                  closeFunction: showDrawer,
                ),

            ],
            staggeredTiles: [
              StaggeredTile.extent(4, 250.0),
              StaggeredTile.extent(4, 250.0),

              StaggeredTile.extent(2, 250.0),
              StaggeredTile.extent(2, 120.0),
              StaggeredTile.extent(2, 120.0),
              StaggeredTile.extent(4, 250.0),
            ],
          ),
        ),
      );
    }*/
  }


