import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String formatted = DateFormat('EEE dd MMM HH:mm').format(dateTime);
  return formatted;
}

String formatDateTime(DateTime dateTime) {
  return DateFormat('EEE dd MMM HH:mm').format(dateTime);
}

String formatTimeAgo(Timestamp timestamp) {
  final timestampInt = timestamp.millisecondsSinceEpoch;
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInt);
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  return timeago.format(now.subtract(difference));
}
