// import 'dart:convert';
// import 'dart:io';
import 'package:cites/screens/generatepdf.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Align the QR Code to Scan"),
        centerTitle: true,
        // backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
                    Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                flex: 1,
                child: Center(child: Text('Scan CITES Code')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   this.controller = controller;
  //   controller.scannedDataStream.listen((scanData) async {
  //     controller.pauseCamera();

  //     var code = scanData.code;
  //     print(code);
  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //       return DisplayPage(data: code as String);
  //     }));
  //   });
  // }

  //THIS IS WORKING
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();

      var code = scanData.code;
      print(code);

      // Trigger the PDF opening logic here
      //API goes here
      String pdfUrl =
          "http://192.168.0.128/cites/v1/certificates/$code.pdf"; // Adjust this according to your API
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return PDFHome(pdfUrl: pdfUrl); // Pass the URL to the PDF screen
          },
        ),
      );
    });
  }
}
