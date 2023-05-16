// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class ScanPage extends StatefulWidget {
//   const ScanPage({super.key});

//   @override
//   State<ScanPage> createState() => _ScanPageState();
// }

// class _ScanPageState extends State<ScanPage> {
//   final qrKey = GlobalKey(debugLabel: 'QR');
//   Barcode? barcode;
//   QRViewController? controller;

//   @override
//   void reassemble() async {
//     super.reassemble();

//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }

//   @override
//   Widget build(BuildContext context) => SafeArea(
//           child: Scaffold(
//         body: Stack(
//           alignment: Alignment.center,
//           children: <Widget>[
//             // buildQrView(context),
//             // Positioned(
//             //   bottom: 25,
//             //   child: buildResult(),
//             // ),
//             // Positioned(
//             //   bottom: 25,
//             //   left: 10,
//             //   child: buildControlButtons(),
//             // )
//           ],
//         ),
//       ));

//   Widget buildControlButtons() => Row(
//         children: <Widget>[
//           Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                   border: Border.all(color: Colors.white),
//                   borderRadius: const BorderRadius.all(Radius.circular(25.0))),
//               child: IconButton(
//                 color: Colors.white,
//                 icon: FutureBuilder<bool?>(
//                   future: controller?.getFlashStatus(),
//                   builder: (context, snapshot) {
//                     if (snapshot.data != null) {
//                       return Icon(
//                           snapshot.data! ? Icons.flash_on : Icons.flash_off);
//                     } else {
//                       return Container();
//                     }
//                   },
//                 ),
//                 onPressed: () async {
//                   await controller?.toggleFlash();
//                   setState(() {});
//                 },
//               )),
//         ],
//       );

//   Widget buildResult() => Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.white24,
//         ),
//         child: Text(
//           barcode != null ? 'Result : ${barcode!.code}' : 'Scan a QR!',
//           maxLines: 3,
//         ),
//       );

//   Widget buildQrView(BuildContext context) => QRView(
//         key: qrKey,
//         onQRViewCreated: onQRViewCreated,
//         overlay: QrScannerOverlayShape(
//           borderColor: Theme.of(context).accentColor,
//           borderRadius: 10,
//           borderLength: 20,
//           borderWidth: 10,
//           cutOutSize: MediaQuery.of(context).size.width * 0.8,
//         ),
//       );

//   void onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });

//     controller.scannedDataStream
//         .listen((barcode) => setState(() => this.barcode = barcode));
//   }
// }
