import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:practices/views/mybottomnavigationbar.dart';
import 'package:practices/views/signinpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: "AIzaSyBAXTqVCMz33SAY2dw9UGe63_qtanzpaak",
      appId: "1:237749456251:web:19be7f2ac4fb2b71a041de",
      messagingSenderId: "237749456251",
      projectId: "findhostel-7ff2d",
    ),
  );
  // var result = await FlutterNotificationChannel.registerNotificationChannel(
  //   description: 'For showing notification',
  //   id: 'Find Hostel',
  //   importance: NotificationImportance.IMPORTANCE_HIGH,
  //   name: 'Find Hostel',
  // );
  //log("Notification channel Result: $result");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}



