import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:resqtrack1/authentication/login_screen.dart';
import 'package:resqtrack1/authentication/signup_screen.dart';
import 'package:resqtrack1/screens/map_screen.dart';
import 'package:resqtrack1/screens/Connect_call.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResQTrack1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      // initialRoute: '/login',
      // routes: {
      //   '/login': (context) => LoginScreen(),
      //   '/signup': (context) => SignupScreen(),
      //   '/map': (context) => const MapScreen(),
      // },
      home: FirebaseAuth.instance.currentUser == null ? LoginScreen() : MapScreen(),
    );
  }
}
