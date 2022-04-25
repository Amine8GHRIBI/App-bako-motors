import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
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
  late UserDatabase database;
  late User user;
  bool _showDrawer = false;
  List<OBD> obds = [];
 List<OBD> newobd = [];

  Future<List<OBD>> retrieveOBD(UserDatabase db) async {
    obds =await this.database.obdDAO.retrieveAllOBD();
    //debugPrint("obd  your " + obds.length.toString());
    setState(() {});
    return obds;
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


  @override
  void initState()  {
    super.initState();
    Future.delayed(Duration.zero,() {
      //  retrieveOBD(this.widget.database);
      //debugPrint("obd diagno " + obds.last.speed.toString());
      setState(() async {
        database = this.widget.database;
        user = this.widget.user;
       newobd = await retrieveOBD(this.database);
        debugPrint("obd your " + newobd.last.speed.toString());
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

   // setState(() {});
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
                'Your Bako' + newobd.length.toString() ,
                style: TextStyle(fontSize: 25,color: HexColor("#175989"), fontWeight: FontWeight.bold),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 35),
                child: Text(
                  'MODEL X',
                  style: TextStyle(fontSize: 35,color: HexColor("#175989"), fontWeight: FontWeight.w200),
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
                        '80%',
                        style:
                            TextStyle(fontSize: 40, color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        'Charged',
                        style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black),
                      )
                    ],
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: kPrimaryColor,
                backgroundColor: kProgressBackGroundColor,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('lib/tesla_app/images/lighting.svg'),
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Text('Charging.. 14 mins remaining', style: TextStyle(color: HexColor("#175989"), fontWeight: FontWeight.w200),
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
                      color: kCardColor,
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
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Today'),
                              SizedBox(height: 10),
                              Center(
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: this.newobd.last.speed.toString(),
                                        style: TextStyle(
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold,
                                            color: kPrimaryColor)),
                                    WidgetSpan(
                                      child: Transform.translate(
                                        offset: Offset(0, -12),
                                        child: Text('km',
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: kPrimaryColor)),
                                      ),
                                    )
                                  ]),
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
                      color: kCardColor,
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
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Today'),
                              SizedBox(height: 10),
                              Center(
                                child: Text('4.3',
                                    style: TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor)),
                              )
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
