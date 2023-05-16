import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/viewmodels/user_view_model.dart';
import 'package:haan_r_haan/src/widgets/loading_dialog.dart';

import '../models/party_model.dart';

class PartyViewModel with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final UserViewModel userViewModel = UserViewModel();

  Stream<List<PartyModel>> fetchPartiesAsMember() {
    return _firestore
        .collection('parties')
        // .orderBy('updatedAt', descending: true)
        .where('members', arrayContains: _auth.currentUser!.uid)
        .where('isDraft', isEqualTo: false)
        .where('ownerID', isNotEqualTo: _auth.currentUser!.uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => PartyModel.fromFirestore(doc),
              )
              .toList(),
        );
  }

  Stream<List<PartyModel>> fetchPartiesAsOwner() {
    return _firestore
        .collection('parties')
        .where('ownerID', isEqualTo: _auth.currentUser!.uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => PartyModel.fromFirestore(doc),
              )
              .toList(),
        );
  }

  //craete party
  createParty({
    required String partyName,
    required String partyDesc,
    required String promptpay,
    context,
  }) async {
    loadingDialog(context);
    final userData = await userViewModel.fetchUser();

    if (promptpay == "") {
      promptpay = userData.phoneNumber;
    }
    print("promptpay: $promptpay");
    final craeteParty = await _firestore
        .collection('parties')
        .add(
          PartyModel(
            partyID: "",
            partyName: partyName,
            partyDesc: partyDesc,
            foodList: [],
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now(),
            totalAmount: 0,
            totalLent: 0,
            paymentList: [],
            paidCount: 0,
            isDraft: true,
            members: [userData.uid],
            ownerID: userData.uid,
            ownerName: userData.username,
            promptpay: promptpay,
            membersJoinedByLink: [],
          ).toFirestore(),
        )
        .then((value) => value.update({
              'partyID': value.id,
            }));
    //Update partiesAsOwnerCount to user
    // await _firestore.collection('users').doc(userData.uid).update({
    //   'partiesAsOwnerCount': userData.partiesAsOwnerCount + 1,
    // });

    Navigator.pop(context);
    notifyListeners();
    return craeteParty;
  }
}
