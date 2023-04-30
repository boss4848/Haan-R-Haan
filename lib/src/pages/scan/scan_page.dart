import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Row(children: const [
          Text(
            "QR Code Scaner",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 30),
          )
        ]),
        backgroundColor: const Color.fromRGBO(35, 34, 72, 1.0),
        toolbarHeight: 80,
      ),
      body: Container(
        color: Colors.blue,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
          color: const Color.fromRGBO(35, 34, 72, 1.0),
          alignment: Alignment.center,
          child: const Text(
            "Place the QR code in the scan poisition",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    ));
  }
}
