import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/widgets/loading_dialog.dart';
import '../models/noti_model.dart';

class NotiViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late NotiModel _noti;
  NotiModel get noti => _noti;

  clearAllNoti() {
    _firestore
        .collection('notifications')
        .where('receiver', isEqualTo: _auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    notifyListeners();
  }

  Stream<List<NotiModel>> getNotificationStream() {
    return _firestore
        .collection('notifications')
        .where('receiver', isEqualTo: _auth.currentUser!.uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => NotiModel.fromFirestore(doc)).toList(),
        );
  }

  Future<void> updateNoti({
    required String title,
    required String body,
    required String sender,
    required String receiver,
    required String type,
  }) async {
    try {
      // Create a new document reference
      DocumentReference docRef = _firestore.collection('notifications').doc();

      // Use the document ID as the notiId
      final NotiModel newNoti = NotiModel(
        title: title,
        body: body,
        notiId: docRef.id,
        sender: sender,
        receiver: receiver,
        createdAt: Timestamp.now(),
        type: type,
        notified: false,
        combinedID: [
          sender,
          receiver,
        ],
      );

      // Set the new document in Firestore
      await docRef.set(newNoti.toFirestore());
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
  // Future<NotiModel> fetchNoti() async {
  //   try {
  //     DocumentSnapshot<Map<String, dynamic>> notiDoc = await _firestore
  //         .collection('notis')
  //         .where('email', isEqualTo: _auth.currentUser!.email)
  //         .get()
  //         .then((value) => value.docs.first);
  //     _noti = NotiModel.fromFirestore(notiDoc);
  //   } catch (e) {
  //     rethrow;
  //   }
  //   notifyListeners();
  //   return _noti;
  // }

  // Future<NotiModel> fetchNotiByID(String notiID) async {
  //   try {
  //     DocumentSnapshot<Map<String, dynamic>> notiDoc =
  //         await _firestore.collection('notis').doc(notiID).get();
  //     _noti = NotiModel.fromFirestore(notiDoc);
  //   } catch (e) {
  //     rethrow;
  //   }
  //   notifyListeners();
  //   return _noti;
  // }
}
