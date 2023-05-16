import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:haan_r_haan/firebase_options.dart';
import 'package:haan_r_haan/src/services/noti_service.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotiService().initNotification();
  runApp(const MainApp());
}
