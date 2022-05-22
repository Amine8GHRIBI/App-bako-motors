import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mini_project/tesla_app/screens/base_screen.dart';
import 'package:widget_loading/widget_loading.dart';

import '../../DataBase/user_database.dart';
import '../../data/CarEntity.dart';
import '../../data/userEntity.dart';

class loading extends StatefulWidget {
  UserDatabase? database;
  User? user;
  Car? car;
  ThemeData? theme;
  loading({Key? key , this.car , this.database , this.user }) : super(key: key);

  @override
  State<loading> createState() => _loadingState();
}

class _loadingState extends State<loading> {
  int counter = 0;
  bool loading = true;

  late Future<Widget> future;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = Stream.periodic(Duration(seconds: 4)).listen((i) {
      setState(() {
        loading = !loading;
        counter++;
      });
    });

    future = Future.delayed(
      Duration(seconds: 4),
          () => Padding(
        padding: EdgeInsets.all(15.0),
        child: ListTile(
          onTap: () {
            Get.to(BaseScreen(user: this.widget.user!,database: this.widget.database!, car: this.widget.car!,));
          },
          leading: Text(
            'Loaded!',
            style: Theme.of(context).textTheme.headline5,
          ),
          trailing: Icon(
            Icons.account_circle,
            size: 50,
            
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: Center(
        child: ConstrainedBox(
          // Constraints for a nicer look in web demo
          constraints: BoxConstraints.loose(Size.fromWidth(750.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: WiperLoading.future(
                        minWidth: double.infinity,
                        future: future,
                      ),
                    ),
                  ),
                  counterCard(Curves.easeInOutCirc,
                      builder: (width, height) => Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(5.0))),
                      wiperWidth: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget counterCard(Curve curve,
      {WiperBuilder? builder,
        double wiperWidth = 15,
        double deformingFactor = 0.5,
        WiperDirection direction = WiperDirection.right,
        EdgeInsetsGeometry padding = const EdgeInsets.all(15.0)}) =>
      Card(
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: WiperLoading(
            wiperDeformingFactor: deformingFactor,
            curve: curve,
            wiperBuilder: builder,
            wiperWidth: wiperWidth,
            direction: direction,
            loading: loading,
            child: Padding(
              padding: padding,
              child: ListTile(
                leading: Text(
                  'Counter',
                  style: Theme.of(context).textTheme.headline5,
                ),
                trailing: Text(
                  '$counter',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
          ),
        ),
      );

  Widget counterCardCircle(Curve curve, {WiperBuilder? builder}) => InkWell(
    onTap: () => Navigator.of(context)
        .push(MaterialPageRoute(builder: (c) => LoadingScaffold())),
    child: Card(
      elevation: 5.0,
      child: CircularWidgetLoading(
        dotColor: Colors.red,
        dotCount: 10,
        rollingFactor: 0.8,
        loading: loading,
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 15.0, vertical: 50.0),
            child: ListTile(
              leading: Text(
                'Counter',
                style: Theme.of(context).textTheme.headline5,
              ),
              trailing: Text(
                '$counter',
                style: Theme.of(context).textTheme.headline5,
              ),
            )),
      ),
    ),
  );
}

class LoadingScaffold extends StatefulWidget {
  @override
  _LoadingScaffoldState createState() => _LoadingScaffoldState();
}

class _LoadingScaffoldState extends State<LoadingScaffold> {
  Future future = Future.delayed(Duration(seconds: 3));

  late StreamSubscription _subscription;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    _subscription = Stream.periodic(Duration(seconds: 4)).listen((i) {
      setState(() {
        loading = !loading;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CircularWidgetLoading(
        padding: EdgeInsets.zero,
        child: Scaffold(
          appBar: AppBar(title: Text('Example')),
          body: Center(child: Text('Loaded!')),
        ),
        loading: loading,
      ),
    );
  }
}
