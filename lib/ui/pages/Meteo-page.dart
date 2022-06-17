import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Gallerie-page.dart';

class MeteoPage extends StatefulWidget {
  const MeteoPage({Key? key}) : super(key: key);

  @override
  State<MeteoPage> createState() => _MeteoPageState();
}

class _MeteoPageState extends State<MeteoPage> {
  int counter = 0;


  @override
  void initState(){
    super.initState();
    print("initialisation");
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return  AnimatedTheme(
      duration: const Duration(milliseconds: 300),
    data: Theme.of(context),
    child  : Scaffold(
      appBar: AppBar(title: const Text('Méteo Page'),),
      body: Column(
        children: [
          Center(
            child :Text("Counter Value $counter ",
             style: theme.textTheme.headline6),
             ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),

            child: ElevatedButton(
              onPressed: () {
                AdaptiveTheme.of(context).toggleThemeMode();
                },
              child: const Text('Changer le thème'),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: theme.primaryColor,
              child: ElevatedButton(

                onPressed: () {
                  AdaptiveTheme.of(context).setDark();

                },
                child: const Text('Changer le thème'),
              ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),

            child: ElevatedButton(
              onPressed: () {
                Get.to(const GalleriePage(),);
                },
              child: const Text('GO'),
            ),
          )
        ],

      ),
    ),
    );
  }
}
