import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

import '../../../DataBase/user_database.dart';
import '../../../data/CarEntity.dart';
import '../../../data/userEntity.dart';
import '../slider_page.dart';

class ScanPage extends StatefulWidget {
  final UserDatabase database;
  final User? use;
  ThemeData? theme;
  Car? car;
  @override
  _ScanPageState createState() => _ScanPageState();
  ScanPage({Key? key , required this.theme,required this.database,this.car,this.use }) : super(key: key);

}

class _ScanPageState extends State<ScanPage> {
  String qrCodeResult = "Not Yet Scanned";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.theme!.primaryColor,
        title: const Text("Scanner"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              "Result",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              qrCodeResult,
              style: const TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20.0,
            ),
            FlatButton(
              padding: const EdgeInsets.all(15.0),
              onPressed: () async {
                String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);

                setState(() {
                  if(barcodeScanRes == "bakomotors"){
                    Get.to(slider_connexion(use : widget.use , database : widget.database , car : widget.car,theme : widget.theme ));
                  }else{
                    barcodeScanRes ="failed car";
                  }
                  qrCodeResult = barcodeScanRes;


                });

                // try{
                //   BarcodeScanner.scan()    this method is used to scan the QR code
                // }catch (e){
                //   BarcodeScanner.CameraAccessDenied;   we can print that user has denied for the permisions
                //   BarcodeScanner.UserCanceled;   we can print on the page that user has cancelled
                // }


              },
              child: Text(
                "Open Scanner",
                style:
                TextStyle(color: widget.theme!.primaryColor, fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: widget.theme!.primaryColor),
                  borderRadius: BorderRadius.circular(20.0)
              ),
            )
          ],
        ),
      ),
    );
  }
    //its quite simple as that you can use try and catch staatements too for platform exception
}