import 'package:flutter/material.dart';
import 'package:my_flutter_app/Login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_flutter_app/page/parent/exnotifiaction.dart';
import 'package:my_flutter_app/page/parent/notifications.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNotifications.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login_Page(),
      theme: ThemeData(scaffoldBackgroundColor: Color(0xFFFCF5ED)),
    );
  }
}
