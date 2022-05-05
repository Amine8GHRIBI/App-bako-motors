import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:settings_ui/settings_ui.dart';

import '../widget/languagesscreen.dart';

class SettingsScreen extends StatefulWidget {
  //ThemeData theme ;
  SettingsScreen({Key? key }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
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
      appBar: AppBar(title:  Text('Diagnostics', style: TextStyle(color : theme.primaryColor),), backgroundColor: theme.cardTheme.color),
      body: buildSettingsList(),
    );
  }

  Widget buildSettingsList() {
    ThemeData theme = Theme.of(context);

    return SettingsList(
      sections: [
        SettingsSection(
          title:   Text( 'Commun ',
            textAlign: TextAlign.right,

            style: GoogleFonts.poppins(
              color:   theme.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),),
          tiles: [
            SettingsTile(
              title: Text('Language'),
              //title: const Text('English'),
              leading: Icon(Icons.language),
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => LanguagesScreen(),
                ));
              },
            ),
           /* CustomTile(
              child: Container(
                color: Color(0xFFEFEFF4),
                padding: EdgeInsetsDirectional.only(
                  start: 14,
                  top: 12,
                  bottom: 30,
                  end: 14,
                ),
                child: Text(
                  'You can setup the language you want',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w400,
                    fontSize: 13.5,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),*/
            SettingsTile(
              title: Text('Environment'),
              //subtitle: 'Production',
              leading: Icon(Icons.cloud_queue),
            ),
          ],
        ),
        SettingsSection(
          title: Text('Account'),
          tiles: [
            SettingsTile(title: Text('Phone number'), leading: Icon(Icons.phone)),
            SettingsTile(title: Text('Email'), leading: Icon(Icons.email)),
            SettingsTile(title: Text('Sign out'), leading: Icon(Icons.exit_to_app)),
          ],
        ),
        SettingsSection(
          title: Text('Security'),
          tiles: [

            SettingsTile.switchTile(
              title: Text('Lock app in background'),
              leading: Icon(Icons.dark_mode),
              onToggle: (bool value) {
                print(value);
                if (value == true) {
                  AdaptiveTheme.of(context).setDark();
                  debugPrint("true dark");
                  // iconAdress = 'assets/icon/dark-icon.png';
                  //icon: Image.asset('assets/icon/dark-icon.png');
                } else {
                  AdaptiveTheme.of(context).setLight();
                  debugPrint("false light");

                  //icon: Image.asset('assets/icons/light-icon.png');
                }
                setState(() {
                  lockInBackground = value;
                  notificationsEnabled = value;
                  darkmode = value;
                });
              },
               initialValue: lockInBackground,
            ),
            SettingsTile.switchTile(
              title: Text('Use fingerprint'),
              //subtitle: 'Allow application to access stored fingerprint IDs.',
              leading: Icon(Icons.fingerprint),
              onToggle: (bool value) {},
              //switchValue: false,
              initialValue: false,
            ),

            SettingsTile.switchTile(
              title: Text('Enable Notifications'),
              enabled: notificationsEnabled,
              leading: Icon(Icons.notifications_active),
              //switchValue: true,
              onToggle: (value) {},
              initialValue: true,
            ),
          ],
        ),
        SettingsSection(
          title: Text('Misc'),
          tiles: [
            SettingsTile(
                title: Text('Terms of Service'), leading: Icon(Icons.description)),
            SettingsTile(
                title: Text('Open source licenses'),
                leading: Icon(Icons.collections_bookmark)),
          ],
        ),

     /*   CustomSection(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 22, bottom: 8),
                child: Image.asset(
                  'assets/settings.png',
                  height: 50,
                  width: 50,
                  color: Color(0xFF777777),
                ),
              ),
              Text(
                'Version: 2.4.0 (287)',
                style: TextStyle(color: Color(0xFF777777)),
              ),
            ],
          ),
        ),*/
      ],

    );
  }
}
