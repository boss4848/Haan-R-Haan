import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/friend_request_model.dart';
import '../models/user_model_draft.dart';
import '../services/notification_service.dart';

class FriendViewModel extends ChangeNotifier {
  List<UserModel> _friendList = [];
  List<Map<String, dynamic>> _friendRequests = [];
  //get
  List<UserModel> get friendList => _friendList;
  List<Map<String, dynamic>> get friendRequests => _friendRequests;
  final NotificationService _notificationService;
  Map<String, StreamSubscription> _friendRequestListeners = {};

  FriendViewModel(this._notificationService);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> get friendRequestsStream async* {
    await for (QuerySnapshot snapshot in _firestore
        .collection('friendRequests')
        .where('receiverID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()) {
      List<Map<String, dynamic>> friendRequests = [];
      for (var doc in snapshot.docs) {
        FriendRequestModel request = FriendRequestModel.fromFirestore(doc);
        UserModel? senderDetails = await fetchUserDetails(request.senderID);

        if (senderDetails != null) {
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
      }
      yield friendRequests;
    }
  }

  Stream<List<UserModel>> get friendListStream async* {
    final currentUserId = await _firestore
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get();

    await for (DocumentSnapshot userDoc in _firestore
        .collection('users')
        .doc(currentUserId.docs.first.id)
        .snapshots()) {
      List<String> friendIds = List<String>.from(userDoc['friendList'] ?? []);
      List<UserModel> friends = [];

      for (String friendId in friendIds) {
        DocumentSnapshot friendDoc =
            await _firestore.collection('users').doc(friendId).get();
        UserModel friend = UserModel.fromFirestore(friendDoc);
        friends.add(friend);
      }
      yield friends;
    }
  }

  Future<void> _listenForFriendRequest(String requestId) async {
    // If there's already a listener for this requestId, don't add another one.
    if (_friendRequestListeners.containsKey(requestId)) {
      return;
    }

    _friendRequestListeners[requestId] = _firestore
        .collection('friendRequests')
        .doc(requestId)
        .snapshots()
        .listen((doc) async {
      if (doc.exists && !doc['isSeen']) {
        await _handleNewFriendRequest(doc);
      }
    });
  }

  void listenForNewFriendRequests(String userId) {
    _firestore
        .collection('friendRequests')
        .where('receiverID', isEqualTo: userId)
        .snapshots()
        .listen((querySnapshot) {
      for (var docChange in querySnapshot.docChanges) {
        if (docChange.type == DocumentChangeType.added &&
            !docChange.doc.metadata.hasPendingWrites) {
          _handleNewFriendRequest(docChange.doc);
        }
      }
    });
  }

  Future<void> _handleNewFriendRequest(DocumentSnapshot doc) async {
    final requestId = doc.id;
    final isSeen = doc['isSeen'];

    if (!isSeen) {
      FriendRequestModel request = FriendRequestModel.fromFirestore(doc);
      UserModel? senderDetails = await fetchUserDetails(request.senderID);

      if (senderDetails != null) {
        _notificationService.showNotification(
          title: "New Friend Request",
          body: "${senderDetails.username} has sent you a friend request.",
        );
        await _firestore.collection('friendRequests').doc(requestId).update(
          {'isSeen': true},
        );
      }
    }
  }

  // Fetch friend list
  Future<void> fetchFriendList(String userId) async {
    try {
      //get userId from firestore
      final currentUserId = await _firestore
          .collection('users')
          .where(
            'email',
            isEqualTo: FirebaseAuth.instance.currentUser?.email,
          )
          .get();
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(
            currentUserId.docs.first.id,
          )
          .get();
      print('userId: $userId');
      List<String> friendIds = List<String>.from(userDoc['friendList'] ?? []);

      _friendList = [];

      for (String friendId in friendIds) {
        DocumentSnapshot friendDoc =
            await _firestore.collection('users').doc(friendId).get();
        UserModel friend = UserModel.fromFirestore(friendDoc);
        _friendList.add(friend);
      }

      notifyListeners();
    } catch (e) {
      // print(e);
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
          'timestamp': DateTime.now(),
          'status': false, // False means the request is pending
          'isSeen': false, // False means the request is not seen yet
        });
        notifyListeners();
      } else {
        //return friend request model
        throw 'Friend request already exists';
      }
    } catch (e) {
      // Print the error message
      print(e);
      rethrow;
    }
  }

  // Fetch user details by ID
  Future<UserModel?> fetchUserDetails(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

// Fetch friend requests
  Future<void> fetchFriendRequests(String userId) async {
    try {
      //get userId from firestore
      final currentUserId = await _firestore
          .collection('users')
          .where(
            'email',
            isEqualTo: FirebaseAuth.instance.currentUser?.email,
          )
          .get();
      QuerySnapshot querySnapshot = await _firestore
          .collection('friendRequests')
          .where(
            'receiverID',
            isEqualTo: currentUserId.docs.first.id,
          )
          .get();
      List<FriendRequestModel> friendRequestsList = querySnapshot.docs
          .map((doc) => FriendRequestModel.fromFirestore(doc))
          .toList();
      _friendRequests = [];
      for (FriendRequestModel request in friendRequestsList) {
        UserModel? senderDetails = await fetchUserDetails(request.senderID);
        if (senderDetails != null) {
          _friendRequests.add({
            'id': request.id,
            'senderID': request.senderID,
            'receiverID': request.receiverID,
            'request': request,
            'status': request.status,
            'timestamp': request.timestamp,
            'senderDetails': senderDetails,
          });
          // Add listener for changes to this friend request
          await _listenForFriendRequest(request.id);
        }
      }

      notifyListeners();
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  Future<void> removeFriend(String userId, String friendUserId) async {
    try {
      //get userId from firestore
      final currentUserId = await _firestore
          .collection('users')
          .where(
            'email',
            isEqualTo: FirebaseAuth.instance.currentUser?.email,
          )
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

      // Update the local friend list
      fetchFriendList(currentUserId.docs.first.id);
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  // Accept friend request
  Future<void> acceptFriendRequest(
    String requestId,
    String senderId,
    String receiverId,
  ) async {
    try {
      // Remove the friend request from the 'friendRequests' collection
      await _firestore.collection('friendRequests').doc(requestId).delete();
      //fetch user details
      UserModel? senderDetails = await fetchUserDetails(senderId);
      UserModel? receiverDetails = await fetchUserDetails(receiverId);
      // Add both users to each other's friends list
      await _firestore.collection('users').doc(senderId).update({
        'friendList': FieldValue.arrayUnion([receiverId]),
        'history': FieldValue.arrayUnion(
          [
            {
              'type': 'friendRequest',
              'title': 'Friend Request Accepted',
              'message':
                  'You are now friends with ${receiverDetails?.username}',
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
              'message': 'You are now friends with ${senderDetails?.username}',
              'timestamp': DateTime.now(),
            }
          ],
        ),
      });

      fetchFriendList("");
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
