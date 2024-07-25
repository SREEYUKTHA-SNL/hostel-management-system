import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:my_flutter_app/Login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_flutter_app/page/parent/notifications.dart';
import 'package:my_flutter_app/page/warden/feedetails.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 10));
  FlutterNativeSplash.remove();
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
      home: feedetails(),
      theme: ThemeData(scaffoldBackgroundColor: Color(0xFFFCF5ED)),
    );
  }
}
