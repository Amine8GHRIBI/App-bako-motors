import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';


class wifi_home extends StatefulWidget {
  const wifi_home({Key? key}) : super(key: key);

  @override
  State<wifi_home> createState() => _wifi_homeState();
}

class _wifi_homeState extends State<wifi_home> {
  @override
  void initState() {
    /// Call out to intialize platform state.
    initPlatformState();
    super.initState();
  }

  /// Initialize platform state.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  /// Widget build method to return MaterailApp.
  @override
  Widget build(BuildContext context) {
    var actionItems = getListOfActionButtons();
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('App Settings Example App'),
            ),
            body: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2,
                children: List.generate(actionItems.length, (index) {
                  return Center(
                      child: ButtonTheme(
                        colorScheme: const ColorScheme.dark(),
                        minWidth: 150.0,
                        child: actionItems[index],
                      ));
                }))));
  }

  List<Widget> getListOfActionButtons() {
    var actionItems = <Widget>[];

    actionItems.addAll([
      ElevatedButton(
        child: const Text("WIFI"),
        onPressed: () {
          AppSettings.openWIFISettings();
        },
      ),
      ElevatedButton(
        child: const Text("Location"),
        onPressed: () {
          AppSettings.openLocationSettings();
        },
      ),
      ElevatedButton(
        child: const Text("Security"),
        onPressed: () {
          AppSettings.openSecuritySettings();
        },
      ),
      ElevatedButton(
        child: const Text("Lock & Password"),
        onPressed: () {
          AppSettings.openLockAndPasswordSettings();
        },
      ),
      ElevatedButton(
        child: const Text("App Settings"),
        onPressed: () {
          AppSettings.openAppSettings();
        },
      ),
      ElevatedButton(
        child: const Text("Bluetooth"),
        onPressed: () {
          AppSettings.openBluetoothSettings();
        },
      ),
      ElevatedButton(
        child: const Text("Data Roaming"),
        onPressed: () {
          AppSettings.openDataRoamingSettings();
        },
      ),
      ElevatedButton(
        child: const Text("Date"),
        onPressed: () {
          AppSettings.openDateSettings();
        },
      ),
      ElevatedButton(
        child: const Text("Display"),
        onPressed: () {
          AppSettings.openDisplaySettings();
        },
      ),
      ElevatedButton(
        child: const Text("Notification"),
        onPressed: () {
          AppSettings.openNotificationSettings();
        },
      ),
      ElevatedButton(
        child: const Text("Sound"),
        onPressed: () {
          AppSettings.openSoundSettings();
        },
      ),
      ElevatedButton(
        child: const Text("Internal Storage"),
        onPressed: () {
          AppSettings.openInternalStorageSettings();
        },
      ),
      ElevatedButton(
        child: const Text("Battery optimization"),
        onPressed: () {
          AppSettings.openBatteryOptimizationSettings();
        },
      ),
      ElevatedButton(
        child: const Text("NFC"),
        onPressed: () {
          AppSettings.openNFCSettings();
        },
      ),
      ElevatedButton(
        child: const Text("VPN"),
        onPressed: () {
          AppSettings.openVPNSettings(
            asAnotherTask: true,
          );
        },
      ),
      ElevatedButton(
        child: const Text("Device Settings"),
        onPressed: () {
          AppSettings.openDeviceSettings(
            asAnotherTask: true,
          );
        },
      ),
      ElevatedButton(
        child: const Text("Accessibility"),
        onPressed: () {
          AppSettings.openAccessibilitySettings(
            asAnotherTask: true,
          );
        },
      ),
      ElevatedButton(
        child: const Text("Developer"),
        onPressed: () {
          AppSettings.openDevelopmentSettings(
            asAnotherTask: true,
          );
        },
      ),
      ElevatedButton(
        child: const Text("Hotspot"),
        onPressed: () {
          AppSettings.openHotspotSettings(
            asAnotherTask: true,
          );
        },
      ),
    ]);

    return actionItems;
  }

  /// Dispose method to close out and cleanup objects.
  @override
  void dispose() {
    super.dispose();
  }
}
