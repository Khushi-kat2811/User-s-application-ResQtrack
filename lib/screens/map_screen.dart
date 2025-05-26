import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import 'package:resqtrack1/authentication/login_screen.dart';
import 'package:resqtrack1/global/global_var.dart';
import 'package:resqtrack1/methods/common_methods.dart';
import 'package:resqtrack1/screens/search_destination_page.dart';
import 'package:resqtrack1/screens/video_call_page.dart';

class MapScreen extends StatefulWidget {
  final String? driveruid;
  const MapScreen({Key? key, this.driveruid}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  final CommonMethods cMethods = CommonMethods();

  // LatLng _currentLocation = LatLng(48.8583, 2.2944); // Default location
  LatLng _currentLocation = LatLng(48.8583, 2.2944);
  LatLng? _driverLocation;
  LatLng? _lastDriverLocation;
  List<LatLng> _routePoints = [];
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription<DatabaseEvent>? _driverLocationSub;

  double searchContainerHeight = 276;

  bool _otpGenerated = false;
  String? _generatedOtp;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _listenToDriverLocation();
  }

  @override
  void dispose() {
    _driverLocationSub?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await Geolocator.openLocationSettings();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled.');
        }
      }

      await _checkLocationPermission();
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(_currentLocation, 15.0);
      });

      await getUserInfoAndCheckBlockStatus();
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkLocationPermission() async {
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
      if (status == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }
    if (status == LocationPermission.deniedForever) {
      await openAppSettings();
      throw Exception('Location permission permanently denied.');
    }
  }

  Future<void> getUserInfoAndCheckBlockStatus() async {
    final userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    final snap = await userRef.once();
    if (snap.snapshot.value != null) {
      final data = snap.snapshot.value as Map;
      if (data["blockStatus"] == "no") {
        setState(() {
          userName = data["name"];
        });
      } else {
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
        cMethods.displaySnackbar("You are blocked. Contact admin.", context);
      }
    } else {
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => LoginScreen()));
    }
  }

  String _generateOtp() {
    final random = DateTime.now().millisecondsSinceEpoch % 1000000;
    return random.toString().padLeft(6, '0');
  }

  void _listenToDriverLocation() {
    if (widget.driveruid == null || widget.driveruid!.isEmpty) return;

    final DatabaseReference driverRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(widget.driveruid!)
        .child("PatientAccepted");

    _driverLocationSub = driverRef.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        try {
          final data = Map<String, dynamic>.from(dataSnapshot.value as Map);
          final lat = data["driverLat"];
          final lng = data["driverLng"];
          final ulat = data["patientLat"];
          final ulng = data["patientLng"];
          if (lat != null && lng != null) {
            final LatLng newLocation = LatLng(lat, lng);
            final LatLng UserNewLocation = LatLng(ulat, ulng);
            final distanceToUser = Distance().as(LengthUnit.Meter, newLocation, UserNewLocation);


            if (_lastDriverLocation == null ||
                Distance().as(LengthUnit.Meter, _lastDriverLocation!, newLocation) >= 1) {
              setState(() {
                _driverLocation = newLocation;
                _lastDriverLocation = newLocation;
              });

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _mapController.move(_driverLocation!, 15.0);
                _fetchRoute(_driverLocation!, _currentLocation);
              });
            }

            if (distanceToUser <= 100 && !_otpGenerated) {
              _generatedOtp = _generateOtp();
              _otpGenerated = true;

              final otpRef = FirebaseDatabase.instance
                  .ref()
                  .child("otp")
                  .child(FirebaseAuth.instance.currentUser!.uid);

              otpRef.set({
                "otp": _generatedOtp,
                "timestamp": ServerValue.timestamp,
                "connectedHospital": "",
              });

              //cMethods.displaySnackbar("OTP generated: $_generatedOtp", context);
              if (_generatedOtp != null) {
                _showOtpDialogUntilConnected(_generatedOtp!);
              }

            }
          }
        } catch (e) {
          print("Error parsing driver location: $e");
        }
      }
    });
  }
  // void _showOtpDialogUntilConnected(String otp) {
  //   final otpRef = FirebaseDatabase.instance
  //       .ref()
  //       .child("otp")
  //       .child(FirebaseAuth.instance.currentUser!.uid);
  //
  //   // Show persistent dialog
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("OTP Generated"),
  //         content: Text("Share this OTP with the driver: $otp"),
  //         actions: const [
  //           Text("Waiting for hospital confirmation..."),
  //         ],
  //       );
  //     },
  //   );
  //
  //   // Listen for connectedHospital = "Yes"
  //   otpRef.child("connectedHospital").onValue.listen((event) {
  //     final value = event.snapshot.value;
  //     if (value == "Yes") {
  //       Navigator.of(context, rootNavigator: true).pop(); // Close dialog
  //     }
  //   });
  // }
  void _showOtpDialogUntilConnected(String otp) {
    final otpRef = FirebaseDatabase.instance
        .ref()
        .child("otp")
        .child(FirebaseAuth.instance.currentUser!.uid);

    // Show persistent dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("OTP Generated"),
          content: Text("Share this OTP with the driver: $otp"),
          actions: const [
            Text("Waiting for hospital confirmation..."),
          ],
        );
      },
    );

    // Listen for connectedHospital = "Yes"
    otpRef.onValue.listen((event) async {
      final data = event.snapshot.value as Map?;
      if (data != null && data["connectedHospital"] == "Yes") {
        Navigator.of(context, rootNavigator: true).pop(); // Close dialog

        // Stop driver tracking
        await _driverLocationSub?.cancel();
        _driverLocationSub = null;

        // Extract hospital coordinates
        final double? hospitalLat = data["hospital_lat"]?.toDouble();
        final double? hospitalLng = data["hospital_lon"]?.toDouble();

        if (hospitalLat != null && hospitalLng != null && _lastDriverLocation != null) {
          LatLng hospitalLocation = LatLng(hospitalLat, hospitalLng);
          setState(() {
            _routePoints.clear(); // clear old route
          });
          _fetchRoute(_currentLocation, hospitalLocation); // draw route to hospital
        }
      }
    });
  }



  Future<void> _fetchRoute(LatLng start, LatLng end) async {
    const apiKey = "5b3ce3597851110001cf62489d0fc290e5e14ae8abf8e2f63ee8fab0";
    final url = Uri.parse(
      "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}",
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final geometry = decoded['features'][0]['geometry']['coordinates'] as List;
      setState(() {
        _routePoints = geometry.map((point) => LatLng(point[1], point[0])).toList();
      });
    } else {
      print('Failed to fetch route: ${response.body}');
    }
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
            Text(_errorMessage ?? 'Location error occurred'),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: const Text('ResQTrack'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
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
              if (_driverLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _driverLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.car_rental, color: Colors.blue, size: 40),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                  ),
                ],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    color: Colors.blue,
                    strokeWidth: 4.0,
                  ),
                ],
              ),
            ],
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (_errorMessage != null) _buildErrorView(),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text("Hello $userName", style: const TextStyle(color: Colors.white)),
            decoration: const BoxDecoration(color: Colors.black),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About"),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (c) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: -80,
      child: Container(
        height: searchContainerHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _circleButton(Icons.search, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => SearchDestinationPage()));
            }),
            _circleButton(Icons.home, () {}),
            _circleButton(Icons.video_call, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => VideoCallPage(
                    channelName: "emergency_help_123",
                    token: "AGORA_TEMPORARY_TOKEN",
                    uid: 0,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(24),
      ),
      child: Icon(icon, color: Colors.white, size: 25),
    );
  }
}
