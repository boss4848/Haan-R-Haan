import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/src/viewmodels/user_view_model.dart';

import '../models/friend_request_model.dart';
import '../models/user_model.dart';

class FriendViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Search user by username
  Future<List<UserModel>> searchUsers({
    required String username,
  }) async {
    try {
      // Get current user's friends and requests
      UserModel currentUser = await UserViewModel().fetchUser();
      List<String> friendIds = currentUser.friendList;

      //remove friend requests from search results
      final requestDocs = await _firestore
          .collection('friendRequests')
          .where('senderID', isEqualTo: _auth.currentUser!.uid)
          .get();

      List<String> friendRequestIds = [];
      for (var requestDoc in requestDocs.docs) {
        friendRequestIds.add(requestDoc.data()['receiverID']);
      }

      // Fetch users
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: username)
          .where('username', isLessThanOrEqualTo: '$username\uf8ff')
          .get();
      List<UserModel> searchResults = querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .where((user) =>
                  user.username != _auth.currentUser!.displayName &&
                  !friendIds.contains(
                      user.uid) && // Check if the user is not a friend
                  !friendRequestIds.contains(
                      user.uid) // Check if the user is not in friend requests
              )
          .toList();

      return searchResults;
    } catch (e) {
      rethrow;
    }
  }

// Send friend request
  Future<void> sendFriendRequest(String senderID, String receiverID) async {
    try {
      // Check if the friend request already exists
      QuerySnapshot querySnapshot = await _firestore
          .collection('friendRequests')
          .where('senderID', isEqualTo: senderID)
          .where('receiverID', isEqualTo: receiverID)
          .get();

      // If the friend request doesn't exist, create a new one
      if (querySnapshot.docs.isEmpty) {
        await _firestore.collection('friendRequests').add({
          'senderID': senderID,
          'receiverID': receiverID,
          'combinedID': [senderID, receiverID],
          'timestamp': Timestamp.now(),
          'status': false, // False means the request is pending
          // 'isSeen': false, // False means the request is not seen yet
        });

        notifyListeners();
      } else {
        //return friend request model
        throw 'Friend request already exists';
      }
    } catch (e) {
      // Print the error message
      // print(e);
      rethrow;
      // throw 'Friend request already exists';
    }
  }

  //Remove Request
  Future<void> removeFriendRequest(String senderID, String receiverID) async {
    try {
      // If the friend request doesn't exist, create a new one
      await _firestore
          .collection('friendRequests')
          .where(
            'senderID',
            isEqualTo: senderID,
          )
          .where('receiverID', isEqualTo: receiverID)
          .get()
          .then((value) => value.docs.first.reference.delete());

      notifyListeners();
    } catch (e) {
      // Print the error message
      // print(e);
      rethrow;
      // throw 'Friend request already exists';
    }
  }

  Stream<List<Map<String, dynamic>>> get pendingRequestsStream async* {
    final UserViewModel userViewModel = UserViewModel();
    await for (QuerySnapshot snapshot in _firestore
        .collection('friendRequests')
        .where('senderID', isEqualTo: _auth.currentUser?.uid)
        .snapshots()) {
      List<Map<String, dynamic>> pendingRequests = [];
      for (var doc in snapshot.docs) {
        FriendRequestModel request = FriendRequestModel.fromFirestore(doc);
        UserModel? receiverDetails =
            await userViewModel.fetchUserByID(request.receiverID);

        pendingRequests.add({
          'id': request.id,
          'senderID': request.senderID,
          'receiverID': request.receiverID,
          'timestamp': request.timestamp,
          'receiverDetails': receiverDetails,
        });
      }
      yield pendingRequests;
    }
  }

  Stream<List<UserModel>> get membersJoinedByLinkStream async* {
    final UserViewModel userViewModel = UserViewModel();
    final currentUser = await userViewModel.fetchUser();

    // Subscribe to the friend list of the current user
    final currentUserDoc = _firestore.collection('users').doc(currentUser.uid);
    await for (var currentUserSnapshot in currentUserDoc.snapshots()) {
      // Extract the friend list
      final friendList =
          List<String>.from(currentUserSnapshot.data()?['friendList'] ?? []);

      // Fetch all the friend documents
      List<Future<DocumentSnapshot<Map<String, dynamic>>>> friendDocs = [];
      for (final friendID in friendList) {
        final friendDoc = _firestore.collection('users').doc(friendID);
        friendDocs.add(friendDoc.get());
      }

      // Wait for all the friend documents to be fetched
      final friendSnapshots = await Future.wait(friendDocs);

      // Convert to UserModel and yield
      final friendsData = friendSnapshots
          .map((snapshot) => UserModel.fromFirestore(snapshot))
          .toList();
      yield friendsData;
    }
  }

  Stream<List<UserModel>> selectMembersStream(String partyID) async* {
    final UserViewModel userViewModel = UserViewModel();
    final currentUser = await userViewModel.fetchUser();

    // Subscribe to the current user document
    final currentUserDoc = _firestore.collection('users').doc(currentUser.uid);
    await for (var currentUserSnapshot in currentUserDoc.snapshots()) {
      // Extract the friend list
      final friendList =
          List<String>.from(currentUserSnapshot.data()?['friendList'] ?? []);

      // Fetch all the friend documents
      List<Future<DocumentSnapshot<Map<String, dynamic>>>> friendDocs = [];
      for (final friendID in friendList) {
        final friendDoc = _firestore.collection('users').doc(friendID);
        friendDocs.add(friendDoc.get());
      }

      // Wait for all the friend documents to be fetched
      final friendSnapshots = await Future.wait(friendDocs);

      // Convert to UserModel
      final friendsData = friendSnapshots
          .map((snapshot) => UserModel.fromFirestore(snapshot))
          .toList();

      // Fetch 'membersJoinedByLink' from the 'parties' collection

      final String partyId = partyID;
      final partyDoc = _firestore.collection('parties').doc(partyId);
      await for (var partySnapshot in partyDoc.snapshots()) {
        final membersJoinedByLink = List<String>.from(
            partySnapshot.data()?['membersJoinedByLink'] ?? []);

        // Fetch all the member documents
        List<Future<DocumentSnapshot<Map<String, dynamic>>>> memberDocs = [];
        for (final memberId in membersJoinedByLink) {
          final memberDoc = _firestore.collection('users').doc(memberId);
          memberDocs.add(memberDoc.get());
        }

        // Wait for all the member documents to be fetched
        final memberSnapshots = await Future.wait(memberDocs);

        // Convert to UserModel
        final membersData = memberSnapshots
            .map((snapshot) => UserModel.fromFirestore(snapshot))
            .toList();

        // Combine friendsData and membersData and yield
        final combinedData = [...friendsData, ...membersData];
        yield combinedData; // Yield combined data
      }
    }
  }

  Stream<List<UserModel>> get friendListStream async* {
    final UserViewModel userViewModel = UserViewModel();
    final currentUser = await userViewModel.fetchUser();

    // Subscribe to the friend list of the current user
    final currentUserDoc = _firestore.collection('users').doc(currentUser.uid);
    await for (var currentUserSnapshot in currentUserDoc.snapshots()) {
      // Extract the friend list
      final friendList =
          List<String>.from(currentUserSnapshot.data()?['friendList'] ?? []);

      // Fetch all the friend documents
      List<Future<DocumentSnapshot<Map<String, dynamic>>>> friendDocs = [];
      for (final friendID in friendList) {
        final friendDoc = _firestore.collection('users').doc(friendID);
        friendDocs.add(friendDoc.get());
      }

      // Wait for all the friend documents to be fetched
      final friendSnapshots = await Future.wait(friendDocs);

      // Convert to UserModel and yield
      final friendsData = friendSnapshots
          .map((snapshot) => UserModel.fromFirestore(snapshot))
          .toList();
      yield friendsData;
    }
  }

  Stream<List<Map<String, dynamic>>> get friendRequestsStream async* {
    final UserViewModel userViewModel = UserViewModel();
    await for (QuerySnapshot snapshot in _firestore
        .collection('friendRequests')
        .where('receiverID', isEqualTo: _auth.currentUser?.uid)
        .snapshots()) {
      List<Map<String, dynamic>> friendRequests = [];
      for (var doc in snapshot.docs) {
        FriendRequestModel request = FriendRequestModel.fromFirestore(doc);
        UserModel? senderDetails =
            await userViewModel.fetchUserByID(request.senderID);

        friendRequests.add({
          'id': request.id,
          'senderID': request.senderID,
          'receiverID': request.receiverID,
          'request': request,
          'status': request.status,
          'timestamp': request.timestamp,
          'senderDetails': senderDetails,
        });
      }
      yield friendRequests;
    }
  }

  Future<void> removeFriend(String friendUserId) async {
    try {
      //get userId from firestore
      final currentUserId = await _firestore
          .collection('users')
          .where('email', isEqualTo: _auth.currentUser?.email)
          .get();
      // Remove friendUserId from current user's friend list
      await _firestore
          .collection('users')
          .doc(currentUserId.docs.first.id)
          .update({
        'friendList': FieldValue.arrayRemove([friendUserId])
      });

      // Remove currentUserId.docs.first.id from friend user's friend list
      await _firestore.collection('users').doc(friendUserId).update({
        'friendList': FieldValue.arrayRemove([currentUserId.docs.first.id])
      });
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  Future<void> acceptFriendRequest(
    String requestId,
    String senderId,
    String receiverId,
  ) async {
    try {
      // Remove the friend request from the 'friendRequests' collection
      await _firestore.collection('friendRequests').doc(requestId).delete();
      //fetch user details
      final UserViewModel userViewModel = UserViewModel();
      UserModel? senderDetails = await userViewModel.fetchUserByID(senderId);
      UserModel? receiverDetails =
          await userViewModel.fetchUserByID(receiverId);
      // Add both users to each other's friends list
      await _firestore.collection('users').doc(senderId).update({
        'friendList': FieldValue.arrayUnion([receiverId]),
        'history': FieldValue.arrayUnion(
          [
            {
              'type': 'friendRequest',
              'title': 'Friend Request Accepted',
              'message': 'You are now friends with ${receiverDetails.username}',
              'timestamp': DateTime.now(),
            }
          ],
        ),
      });
      await _firestore.collection('users').doc(receiverId).update({
        'friendList': FieldValue.arrayUnion([senderId]),
        'history': FieldValue.arrayUnion(
          [
            {
              'type': 'friendRequest',
              'title': 'Friend Request Accepted',
              'message': 'You are now friends with ${senderDetails.username}',
              'timestamp': DateTime.now(),
            }
          ],
        ),
      });

      notifyListeners();
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  // Decline friend request
  Future<void> declineFriendRequest(String requestId) async {
    try {
      // Remove the friend request from the 'friendRequests' collection
      await _firestore.collection('friendRequests').doc(requestId).delete();

      notifyListeners();
    } catch (e) {
      // print(e);
      rethrow;
    }
  }
}
