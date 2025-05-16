// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:resqtrack1/authentication/login_screen.dart';
// import 'package:resqtrack1/authentication/signup_screen.dart';
//
// Future<void> main() async
// {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget
// {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context)
//   {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: Colors.black,
//       ),
//       home: LoginScreen(),
//     );
//   }
// }

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:resqtrack1/authentication/login_screen.dart';
// import 'package:resqtrack1/authentication/signup_screen.dart';
// import 'package:resqtrack1/screens/map_screen.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   // Check and request location permission
//   await _handleLocationPermission();
//
//   runApp(const MyApp());
// }
//
// Future<void> _handleLocationPermission() async {
//   // Check if permission is granted
//   var status = await Permission.location.status;
//
//   if (status.isDenied) {
//     // Request permission if not granted
//     status = await Permission.location.request();
//
//     if (status.isPermanentlyDenied) {
//       // If permanently denied, open app settings
//       await openAppSettings();
//     }
//   }
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ResQTrack1',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: Colors.black,
//       ),
//       initialRoute: '/login',
//       routes: {
//         '/login': (context) => LoginScreen(),
//         '/signup': (context) => SignupScreen(),
//         '/map': (context) => const MapScreen(),
//       },
//     );
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:resqtrack1/authentication/login_screen.dart';
import 'package:resqtrack1/authentication/signup_screen.dart';
import 'package:resqtrack1/screens/map_screen.dart';
// import 'package:google_map_flutter/OpenStreetMap/openstreetmap.dart';

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/map': (context) => const MapScreen(),
      },
    );
  }
}
