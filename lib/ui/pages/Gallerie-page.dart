import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class GalleriePage extends StatefulWidget {
  GalleriePage({Key? key}) : super(key: key);

  @override
  State<GalleriePage> createState() => _GalleriePageState();
}

class _GalleriePageState extends State<GalleriePage> {
  bool darkmode = false;
  dynamic savedThemeMode;
  late String iconAdress;


  void initState() {
    super.initState();
    getCurrentTheme();
  }

  Future getCurrentTheme() async {
    savedThemeMode = await AdaptiveTheme.getThemeMode();
    if (savedThemeMode.toString() == 'AdaptiveThemeMode.dark') {
      print('mode sombre');
      setState(() {
        darkmode = true;
      });
    } else {
      setState(() {
        darkmode = false;
      });
      print('mode clair');
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Gallerie'),),
      body: Column (
        children: [
      Center(
        child: Text("Gallerie page ",style:  theme.textTheme.headline6,),
      ),
    SwitchListTile(
    title: Text('Mode sombre'),
    value: darkmode,
    activeColor: Colors.orange,
    onChanged: (bool value) {
    print(value);
    if (value == true) {
    AdaptiveTheme.of(context).setDark();
    iconAdress = 'assets/icon/dark-icon.png';
    } else {
    AdaptiveTheme.of(context).setLight();
    iconAdress = 'assets/icons/light-icon.png';
    }
    setState(() {
    darkmode = value;
    });
    },
    secondary: const Icon(Icons.nightlight_round),
    ),

    ],
      ),
    );
  }
}
