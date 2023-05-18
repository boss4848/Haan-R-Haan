import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/widgets/loading.dart';
import 'package:haan_r_haan/src/widgets/loading_dialog.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../constant/constant.dart';
import '../../models/party_model.dart';
import '../../viewmodels/noti_view_model.dart';
import '../../viewmodels/user_view_model.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  QRViewController? controller;
  Future<DocumentSnapshot>? partyDocFuture;
  bool isNavigating = false;

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildQrView(context),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const Spacer(),
                  buildResult(),
                  // buildControlButtons(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          _buildBanner(context),
        ],
      ),
    );
  }

  Container _buildBanner(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: kDefaultBG,
      ),
      height: 140,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Scan QR Code",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildControlButtons() => Row(
        children: <Widget>[
          Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: const BorderRadius.all(Radius.circular(25.0))),
              child: IconButton(
                color: Colors.white,
                icon: FutureBuilder<bool?>(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return Icon(
                          snapshot.data! ? Icons.flash_on : Icons.flash_off);
                    } else {
                      return Container();
                    }
                  },
                ),
                onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {});
                },
              )),
        ],
      );
  Widget buildResult() {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.8),
      ),
      child: Column(
        children: [
          Text(
            barcode != null ? 'PartyID: ${barcode!.code}' : 'Scan a QR!',
            maxLines: 3,
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     setState(() {
          //       barcode = null;
          //       isNavigating = false;
          //     });
          //   },
          //   child: const Text('Find new party'),
          // ),
          if (barcode != null)
            FutureBuilder<DocumentSnapshot>(
              future: partyDocFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.data == null || !snapshot.data!.exists) {
                      return const Text('Party not found!');
                    } else {
                      final party = PartyModel.fromFirestore(snapshot.data!);

                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        if (!isNavigating) {
                          isNavigating = true;
                          controller?.pauseCamera();

                          final user = await UserViewModel().fetchUser();

                          if (party.membersJoinedByLink.contains(
                                FirebaseAuth.instance.currentUser!.uid,
                              ) ||
                              user.friendList.contains(party.ownerID)) {
                            // ignore: use_build_context_synchronously
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              barrierDismissible: false,
                              confirmBtnText: 'Cancel',
                              title: 'You have already joined this party!',
                              backgroundColor: kPrimaryColor,
                            ).then((_) {
                              controller?.resumeCamera();
                              isNavigating = false;
                            });
                          } else {
                            // ignore: use_build_context_synchronously
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.confirm,
                              barrierDismissible: false,
                              confirmBtnColor: kPrimaryColor,
                              confirmBtnText: 'Join',
                              cancelBtnText: 'Cancel',
                              showCancelBtn: true,
                              title: 'Join ${party.partyName}?',
                              backgroundColor: kPrimaryColor,
                              onConfirmBtnTap: () {
                                //Add user to party
                                List<String> membersJoinedByLink =
                                    party.membersJoinedByLink;
                                membersJoinedByLink.add(
                                  FirebaseAuth.instance.currentUser!.uid,
                                );

                                FirebaseFirestore.instance
                                    .collection('parties')
                                    .doc(party.partyID)
                                    .update({
                                  'membersJoinedByLink': membersJoinedByLink,
                                });
                                NotiViewModel().updateNoti(
                                  title: "Joined party by QR code",
                                  body: "You have joined ${party.partyName}",
                                  sender: "",
                                  receiver:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  type: "joinedParty",
                                );

                                NotiViewModel().updateNoti(
                                  title: "Joined party by QR code",
                                  body:
                                      "${user.username} have joined ${party.partyName}",
                                  sender:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  receiver: party.ownerID,
                                  type: "joiendParty",
                                );
                                // notifyListeners();
                              },
                            ).then((_) {
                              controller?.resumeCamera();
                              isNavigating = false;
                            });
                          }
                        }
                      });
                      return Container();
                    }
                  }
                }
              },
            ),
        ],
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen(
      (barcode) {
        if (!isNavigating) {
          // Check if the navigation is not already done
          setState(() {
            print("barcode: ${barcode.code}");
            this.barcode = barcode;
            partyDocFuture = FirebaseFirestore.instance
                .collection('parties')
                .doc(barcode.code)
                .get();
          });
        }
      },
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: kPrimaryColor,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  // void onQRViewCreated(QRViewController controller) {
  //   setState(() {
  //     this.controller = controller;
  //   });

  //   controller.scannedDataStream.listen(
  //     (barcode) => setState(
  //       () => this.barcode = barcode,
  //     ),
  //   );
  // }
}
