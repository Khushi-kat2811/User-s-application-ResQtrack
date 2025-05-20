
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resqtrack1/authentication/login_screen.dart';
import 'package:resqtrack1/global/global_var.dart';
import 'package:resqtrack1/methods/common_methods.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;
  LatLng _currentLocation= LatLng(48.8583,2.2944);
  bool _isLoading = true;
  String? _errorMessage;
  bool _serviceEnabled = false;
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  CommonMethods cMethods = CommonMethods();
  double searchContainerHeight = 276;
  double bottomMapPadding = 0;


  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Check if location services are enabled
      _serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await Geolocator.openLocationSettings();
        if (!_serviceEnabled) {
          throw Exception('Location services are disabled. Please enable them in settings.');
        }
      }

      // 2. Check and request location permissions
      await _checkLocationPermission();

      // 3. Get current position
      await _getCurrentPosition();

    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('LateInitializationError:', '').trim();
        if (_errorMessage!.contains('Field')) {
          _errorMessage = 'Location service initialization failed. Please restart the app.';
        }
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _checkLocationPermission() async {

    final status = await Geolocator.checkPermission();

    if (status==LocationPermission.denied) {
      final result = await Geolocator.requestPermission();
      if (result==LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (status==LocationPermission.deniedForever) {
      await openAppSettings();
      await Future.delayed(const Duration(seconds: 1));
      throw Exception('Location permission permanently denied. Please enable in app settings.');
    }
  }

  Future<void> _getCurrentPosition() async {
    try {
      Position position  = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);

      });
      WidgetsBinding.instance.addPostFrameCallback((_){
        _mapController.move(_currentLocation, 15.0);
      });
    } on TimeoutException{
      throw Exception('Location request timed out. Please try again.');
    } catch (e) {
      throw Exception('Failed to get location: ${e.toString()}');
    }
    await getUserInfoAndCheckBlockStatus();
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 50, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Location error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('Retry'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }

  getUserInfoAndCheckBlockStatus() async{
    DatabaseReference userRef = FirebaseDatabase.instance.ref()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    await userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
          setState(() {
            userName = (snap.snapshot.value as Map)["name"];

          });
          //Navigator.pushReplacementNamed(context, '/map');
        } else {
          FirebaseAuth.instance.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
          cMethods.displaySnackbar("You are blocked. Contact admin: khushi@gmail.com", context);
        }
      } else {
        FirebaseAuth.instance.signOut();
        // cMethods.displaySnackbar("User does not exist.", context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 255,
        color: Colors.black87,
        child: Drawer(
          backgroundColor: Colors.white10,
          child: ListView(
            children: [


              Container(
                color: Colors.black,
                height: 160,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/user.png.jpg",
                        width: 60,
                        height: 60,
                      ),

                      const SizedBox(width: 16,),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4,),

                          const Text(
                            "Profile",
                            style: TextStyle(
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),


              const Divider(
                height: 1,
                color: Colors.white,
                thickness: 1,

              ),


              const SizedBox(height: 10,),

              ListTile(
                leading: IconButton(onPressed: (){},
                    icon: const Icon(Icons.info, color: Colors.grey,),
                ),
                title: const Text("About", style: TextStyle(color: Colors.grey),),
              ),

              GestureDetector(
                onTap: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
                },
                child: ListTile(
                  leading: IconButton(onPressed: (){},
                      icon: const Icon(Icons.logout, color: Colors.grey,),
                  ),
                  title: const Text("Logout", style: TextStyle(color: Colors.grey),),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('ResQTrack'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      // body: _isLoading
      //     ? const Center(child: CircularProgressIndicator())
      //     : _errorMessage != null
      //     ? _buildErrorView()
      //     : FlutterMap(
      //   mapController: _mapController,
      //   options: MapOptions(
      //     initialCenter: _currentLocation,
      //     initialZoom: 15.0,
      //   ),
      //   children: [
      //     TileLayer(
      //       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      //       userAgentPackageName: 'com.example.resqtrack1',
      //     ),
      //     MarkerLayer(
      //       markers: [
      //         Marker(
      //           point: _currentLocation,
      //           width: 40,
      //           height: 40,
      //           child: const Icon(
      //             Icons.location_pin,
      //             color: Colors.red,
      //             size: 40,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          // Map View
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.resqtrack1',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Positioned(
          //     top: 36,
          //     left: 19,
          //     child: GestureDetector(
          //       onTap: (){
          //         sKey.currentState!.openDrawer();
          //       },
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(20),
          //           boxShadow: const [
          //             BoxShadow(
          //               color: Colors.black26,
          //               blurRadius: 5,
          //               spreadRadius: 0.5,
          //               offset: Offset(0.7, 0.7),
          //             )
          //           ]
          //         ),
          //         child: const CircleAvatar(
          //           backgroundColor: Colors.grey,
          //           radius: 20,
          //           child: Icon(
          //               Icons.menu,
          //               color: Colors.black87,
          //           ),
          //         ),
          //       ),
          //     )
          // ),

          // Loading Indicator

          Positioned(
            left: 0,
            right: 0,
            bottom: -80,
            child: Container(
              height: searchContainerHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: (){

                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(24)
                    ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 25,
                      ),
                  ),
                  ElevatedButton(
                    onPressed: (){

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24)
                    ),
                    child: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24)
                    ),
                    child: const Icon(
                      Icons.work,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),

          // Error Message View
          if (_errorMessage != null)
            Positioned.fill(
              child: _buildErrorView(),
            ),
        ],
      ),

    );
  }
}