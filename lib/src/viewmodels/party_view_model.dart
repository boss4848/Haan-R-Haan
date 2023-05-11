import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/party_model.dart';
import '../models/user_model_draft.dart';

class PartyViewModel with ChangeNotifier {
  // Add your logic for managing parties, e.g., a list of parties or a database reference
  List<PartyModel> _parties = [];
  List<PartyModel> get parties => _parties;
  List<UserModel> _selectedFriends = [];
  List<UserModel> get selectedFriends => _selectedFriends;

  final _firestore = FirebaseFirestore.instance;
  fetchPartyByID(String partyID) {
    return _firestore.collection('parties').doc(partyID).snapshots().map(
          (
            DocumentSnapshot partyDoc,
          ) =>
              PartyModel.fromFirestore(
            partyDoc,
          ),
        );
  }

  Future<List<UserModel>> fetchFriends() async {
    final userId = await FirebaseFirestore.instance
        .collection('users')
        .where(
          'email',
          isEqualTo: FirebaseAuth.instance.currentUser!.email,
        )
        .get()
        .then(
          (value) => value.docs[0].id,
        );
    final userDoc = await _firestore.collection('users').doc(userId).get();
    List<String> friendsIds = List<String>.from(userDoc['friendList']);

    List<UserModel> friends = [];
    for (String friendId in friendsIds) {
      final friendDoc = await _firestore
          .collection('users')
          .doc(
            friendId,
          )
          .get();
      friends.add(
        UserModel.fromFirestore(friendDoc),
      );
    }
    // print("friends: $friends");
    return friends;
  }

  Future<void> addFriendsToParty(
      String partyId, List<String> selectedFriendsIds) async {
    final partyDoc = _firestore.collection('parties').doc(partyId);

    await partyDoc.update({
      'members': FieldValue.arrayUnion(selectedFriendsIds),
    });

    notifyListeners();
  }

  addSelectedFriend(UserModel friend) {
    _selectedFriends.add(friend);
    notifyListeners();
  }

  removeSelectedFriend(UserModel friend) {
    _selectedFriends.remove(friend);
    notifyListeners();
  }

  isContainSelectedFriend(UserModel friend) {
    return _selectedFriends.contains(friend);
  }

  Stream<List<PartyModel>> fetchParties() async* {
    String? currentUserID;

    // Fetch the user document and extract the user ID
    await _firestore
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        currentUserID = querySnapshot.docs.first.id;
      }
    });

    print("currentUserID: $currentUserID");

    await _firestore
        .collection('parties')
        .where(
          'ownerID',
          isEqualTo: currentUserID,
        )
        .get()
        .then(
          (value) => print("value: ${value.docs}"),
        );

    // If the user ID is not null, fetch the parties
    if (currentUserID != null) {
      yield* _firestore
          .collection('parties')
          .where('ownerID', isEqualTo: currentUserID)
          .snapshots()
          .map(
            (QuerySnapshot partyQuerySnapshot) => partyQuerySnapshot.docs.map(
              (doc) {
                return PartyModel(
                  id: doc.id,
                  createdAt: doc['createdAt'],
                  foods: List<Map<String, dynamic>>.from(doc['foods']),
                  isDraft: doc['isDraft'],
                  members: List<String>.from(doc['members']),
                  ownerId: doc['ownerID'],
                  ownerName: doc['ownerName'],
                  partyDesc: doc['partyDesc'],
                  partyName: doc['partyName'],
                  payments: List<Map<String, dynamic>>.from(doc['payments']),
                  promptpay: doc['promptpay'],
                  totalAmount: doc['totalAmount'],
                  totalLent: doc['totalLent'],
                  updatedAt: doc['updatedAt'],
                );
                // return PartyModel.fromFirestore(doc);
              },
            ).toList(),
          );
    } else {
      // If the user ID is null, return an empty list
      yield [];
    }
  }

  // Stream<List<PartyModel>> fetchParties() {
  //   final currentUserID = _firestore.collection('users').where(
  //         'email',
  //         isEqualTo: FirebaseAuth.instance.currentUser!.email,
  //       );
  //   print("currentUserID: $currentUserID");

  //   final partiesStream = _firestore
  //       .collection('parties')
  //       .where(
  //         'ownerID',
  //         isEqualTo: currentUserID,
  //       )
  //       .snapshots()
  //       .map((QuerySnapshot partyQuerySnapshot) => partyQuerySnapshot.docs.map(
  //             (doc) {
  //               return PartyModel.fromFirestore(doc);
  //             },
  //           ).toList());
  //   return partiesStream;

  //   // return _firestore
  //   //     .collection('users')
  //   //     .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
  //   //     .snapshots()
  //   //     .asyncMap((querySnapshot) async {
  //   //   String currentUserId = querySnapshot.docs.first.id;
  //   //   print("currentUserId: $currentUserId");
  //   //   return await _firestore
  //   //       .collection('parties')
  //   //       .where('ownerID', isEqualTo: currentUserId)
  //   //       .snapshots()
  //   //       .map((QuerySnapshot partyQuerySnapshot) =>
  //   //           partyQuerySnapshot.docs.map((doc) {
  //   //             return PartyModel.fromFirestore(doc);
  //   //           }).toList())
  //   //       .first;
  //   // });
  // }

  createParty({
    required String partyName,
    required String partyDesc,
    required String promptpay,
  }) async {
    final ownerData = await _firestore
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get();
    final owner = ownerData.docs.first;
    if (promptpay == "") {
      promptpay = owner.data()['phoneNumber'];
    }
    final createData = await _firestore.collection('parties').add({
      'partyName': partyName,
      'partyDesc': partyDesc,
      'ownerName': owner.data()['username'],
      'ownerID': owner.id,
      'promptpay': promptpay,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'members': [owner.id],
      'totalAmount': 0,
      'totalLent': 0,
      'isDraft': true,
      'foods': [],
      'payments': [],
    });

    notifyListeners();
    print('createData.id: ${createData.id}');
    return createData.id;
  }
}
