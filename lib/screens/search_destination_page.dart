import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'map_screen.dart';

class SearchDestinationPage extends StatefulWidget {
  const SearchDestinationPage({super.key});

  @override
  State<SearchDestinationPage> createState() => _SearchDestinationPageState();
}

class _SearchDestinationPageState extends State<SearchDestinationPage> {
  String statusText = "Fetching location...";
  Position? currentPosition;
  late DatabaseReference driverDetailsRef;
  late Stream<DatabaseEvent> driverDetailsStream;
  bool hasNavigated = false; // To prevent multiple navigations
  StreamSubscription<DatabaseEvent>? _driverDetailsSubscription ;

  @override
  void initState() {
    super.initState();
    fetchCurrentLocation();
    setupDriverDetailsListener();
  }
  @override
  void dispose(){
    _driverDetailsSubscription?.cancel();
    super.dispose();
  }


  Future<void> fetchCurrentLocation() async {
    // Same as before...
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        statusText = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          statusText = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        statusText = "Location permissions are permanently denied.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPosition = position;
      statusText =
      "Location found: (${position.latitude}, ${position.longitude})";
    });

    uploadLocationToFirebase(position);
  }

  Future<void> uploadLocationToFirebase(Position position) async {
    // Same as before...
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          statusText = "User not logged in.";
        });
        return;
      }

      String uid = user.uid;
      DatabaseReference usersRef =
      FirebaseDatabase.instance.ref().child("users").child(uid);
      DatabaseReference locationLogRef =
      FirebaseDatabase.instance.ref().child("user_locations").push();

      final userSnapshot = await usersRef.get();

      if (!userSnapshot.exists) {
        setState(() {
          statusText = "User data not found in database.";
        });
        return;
      }

      final userData = userSnapshot.value as Map;

      await usersRef.update({
        "latitude": position.latitude,
        "longitude": position.longitude,
        "lastUpdated": DateTime.now().toIso8601String(),
      });

      await locationLogRef.set({
        "uid": uid,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "timestamp": DateTime.now().toIso8601String(),
        "name": userData["name"] ?? "",
        "email": userData["email"] ?? "",
        "phone": userData["phone"] ?? "",
      });

      setState(() {
        statusText = "In process of sending an ambulance to your location.";
      });
    } catch (e) {
      debugPrint("Error uploading location: $e");
      setState(() {
        statusText = "Failed to upload location to Firebase.";
      });
    }
  }

  void setupDriverDetailsListener() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;



    driverDetailsRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(user.uid)
        .child("DriverDetails");
    _driverDetailsSubscription = driverDetailsRef.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot.value;
      if (dataSnapshot != null && !hasNavigated && mounted) {
        final data = Map<String, dynamic>.from(dataSnapshot as Map);
        // DriverDetails exists - navigate now
        hasNavigated = true;

        // Show connected popup
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Connected to nearest driver"),
            duration: Duration(seconds: 2),
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          if(!mounted)  return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MapScreen(
                driveruid: data["driverId"],
              ),
            ),
          );
        });


      }
    }


    );
  }

  @override
  Widget build(BuildContext context) {
    // Same as before, your UI code ...
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Card(
            elevation: 10,
            margin: const EdgeInsets.only(top: 48, left: 16, right: 16),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon:
                          const Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Connecting to Nearest Hospital",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    statusText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text("Cancel"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
