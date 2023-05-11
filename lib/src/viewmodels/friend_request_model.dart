// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../models/friend_request_model.dart';

// class FriendRequestViewModel extends ChangeNotifier {
//   List<FriendRequestModel> _friendRequests = [];
//   List<FriendRequestModel> get friendRequests => _friendRequests;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Fetch friend requests
//   Future<void> fetchFriendRequests(String userId) async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore
//           .collection('friendRequests')
//           .where('receiver', isEqualTo: userId)
//           .get();
//       _friendRequests = querySnapshot.docs
//           .map((doc) => FriendRequestModel.fromFireStore(doc))
//           .toList();
//       notifyListeners();

//       // Print the results to the console
//       print("Friend requests for user $userId:");
//       for (FriendRequestModel request in _friendRequests) {
//         print('Request from: ${request.sender}, status: ${request.status}');
//       }
//     } catch (e) {
//       // print(e);
//       rethrow;
//     }
//   }

//   // Send friend request
//   // Future<void> sendFriendRequest(
//   //     String username, String anotherUsername) async {
//   //   try {
//   //     await _firestore.collection('friendRequests').add({
//   //       'username': username,
//   //       'anotherUsername': anotherUsername,
//   //       'status': Status.requested.toString(),
//   //     });
//   //     _friendRequests.add(FriendRequestModel(
//   //         username: username,
//   //         anotherUsername: anotherUsername,
//   //         status: Status.requested));
//   //     notifyListeners();
//   //   } catch (e) {
//   //     // print(e);
//   //     throw e;
//   //   }
//   // }

//   // Additional friend request-related functions can be added here
// }
