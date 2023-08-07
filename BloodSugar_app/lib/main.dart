import 'package:bloodsugar_app/authentication/loginPage.dart';
import 'package:bloodsugar_app/flashScreen.dart';
import 'package:flutter/material.dart';
import "route.dart";
import 'package:bloodsugar_app/authentication/loginPage.dart';
import "package:firebase_core/firebase_core.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Blood Sugar Gradient",
      theme: ThemeData(
        primaryColor: Colors.redAccent
      ),
      home: const FlashScreen()
    );
  }
}
