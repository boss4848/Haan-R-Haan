import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> sendNotification({
    required String title,
    required String body,
    required String receiverToken,
  }) async {
    // Use your own server or a third-party service like Firebase Cloud Functions
    // to send push notifications using FCM API.
  }
  Future<String> getToken() async {
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
    return token ?? "";
  }
}
