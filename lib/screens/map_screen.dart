// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ResQTrack"),
        backgroundColor: Colors.black,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(27.1751, 78.0421), // Taj Mahal, India
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(27.1751, 78.0421),
                width: 80.0,
                height: 80.0,
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
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});
//
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   LatLng? _userLocation;
//   late final MapController _mapController;
//   bool _permissionDenied = false;
//   bool _isLoading = true;
//   String? _errorMessage;
//   Position? _currentPosition;
//   double _zoomLevel = 13.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _mapController = MapController();
//     _initLocationService();
//   }
//
//   Future<void> _initLocationService() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       await _checkLocationPermission();
//       await _getCurrentLocation();
//     } catch (e) {
//       setState(() {
//         _errorMessage = "Failed to get location: ${e.toString()}";
//         _permissionDenied = true;
//       });
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _checkLocationPermission() async {
//     final status = await Permission.location.status;
//
//     if (status.isDenied) {
//       final result = await Permission.location.request();
//       if (result.isDenied) {
//         throw Exception('Location permission denied');
//       }
//     }
//
//     if (status.isPermanentlyDenied) {
//       setState(() => _permissionDenied = true);
//       throw Exception('Location permission permanently denied');
//     }
//   }
//
//   Future<void> _getCurrentLocation() async {
//     final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!isServiceEnabled) {
//       throw Exception('Location services are disabled');
//     }
//
//     final position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.best,
//     );
//
//     setState(() {
//       _currentPosition = position;
//       _userLocation = LatLng(position.latitude, position.longitude);
//       _permissionDenied = false;
//     });
//
//     _mapController.move(_userLocation!, _zoomLevel);
//   }
//
//   Future<void> _openAppSettings() async {
//     await openAppSettings();
//     await _initLocationService();
//   }
//
//   Widget _buildPermissionDeniedView() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.location_off, size: 50, color: Colors.red),
//             const SizedBox(height: 16),
//             const Text(
//               "Location Access Required",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "This app needs location permission to show your position on the map.",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.settings),
//               label: const Text("Open Settings"),
//               onPressed: _openAppSettings,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextButton(
//               child: const Text("Try Again"),
//               onPressed: _initLocationService,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingView() {
//     return const Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CircularProgressIndicator(),
//           SizedBox(height: 16),
//           Text("Finding your location..."),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorView() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.error_outline, size: 50, color: Colors.orange),
//             const SizedBox(height: 16),
//             Text(
//               _errorMessage ?? "Unknown error occurred",
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               child: const Text("Retry"),
//               onPressed: _initLocationService,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMapView() {
//     return Stack(
//       children: [
//         FlutterMap(
//           mapController: _mapController,
//           options: MapOptions(
//             center: _userLocation!,
//             zoom: _zoomLevel,
//             interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
//           ),
//           children: [
//             TileLayer(
//               urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//               subdomains: const ['a', 'b', 'c'],
//               userAgentPackageName: 'com.example.resqtrack1',
//             ),
//             MarkerLayer(
//               markers: [
//                 Marker(
//                   point: _userLocation!,
//                   width: 50.0,
//                   height: 50.0,
//                   child: const Icon(
//                     Icons.location_pin,
//                     color: Colors.red,
//                     size: 40,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         Positioned(
//           bottom: 20,
//           right: 20,
//           child: FloatingActionButton(
//             backgroundColor: Colors.black,
//             child: const Icon(Icons.my_location),
//             onPressed: () {
//               if (_userLocation != null) {
//                 _mapController.move(_userLocation!, _zoomLevel);
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ResQTrack"),
//         backgroundColor: Colors.black,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _initLocationService,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? _buildLoadingView()
//           : _permissionDenied
//               ? _buildPermissionDeniedView()
//               : _errorMessage != null
//                   ? _buildErrorView()
//                   : _buildMapView(),
//     );
//   }
// }
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});
//
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   final MapController _mapController = MapController();
//   LatLng? _currentLocation;
//   bool _isLoading = true;
//   String? _errorMessage;
//   bool _serviceEnabled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeLocation();
//   }
//
//   Future<void> _initializeLocation() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       // 1. Check if location services are enabled
//       _serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!_serviceEnabled) {
//         _serviceEnabled = await Geolocator.openLocationSettings();
//         if (!_serviceEnabled) {
//           throw Exception('Location services are disabled. Please enable them in settings.');
//         }
//       }
//
//       // 2. Check and request location permissions
//       await _checkLocationPermission();
//
//       // 3. Get current position
//       await _getCurrentPosition();
//
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString().replaceAll('LateInitializationError:', '').trim();
//         if (_errorMessage!.contains('Field')) {
//           _errorMessage = 'Location service initialization failed. Please restart the app.';
//         }
//       });
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   Future<void> _checkLocationPermission() async {
//     final status = await Permission.location.status;
//
//     if (status.isDenied) {
//       final result = await Permission.location.request();
//       if (result.isDenied) {
//         throw Exception('Location permission denied');
//       }
//     }
//
//     if (status.isPermanentlyDenied) {
//       await openAppSettings();
//       await Future.delayed(const Duration(seconds: 1));
//       throw Exception('Location permission permanently denied. Please enable in app settings.');
//     }
//   }
//
//   Future<void> _getCurrentPosition() async {
//     try {
//       final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.bestForNavigation,
//         timeLimit: const Duration(seconds: 15),
//       ).timeout(const Duration(seconds: 20));
//
//       if (mounted) {
//         setState(() {
//           _currentLocation = LatLng(position.latitude, position.longitude);
//         });
//         _mapController.move(_currentLocation!, 15.0);
//       }
//     } on TimeoutException{
//       throw Exception('Location request timed out. Please try again.');
//     } catch (e) {
//       throw Exception('Failed to get location: ${e.toString()}');
//     }
//   }
//
//   Widget _buildErrorView() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.error_outline, size: 50, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(
//               _errorMessage ?? 'Location error occurred',
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _initializeLocation,
//               child: const Text('Retry'),
//             ),
//             const SizedBox(height: 12),
//             TextButton(
//               onPressed: () => openAppSettings(),
//               child: const Text('Open Settings'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Uber Clone'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _initializeLocation,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _errorMessage != null
//           ? _buildErrorView()
//           : _currentLocation == null
//           ? const Center(child: Text('No location data'))
//           : FlutterMap(
//         mapController: _mapController,
//         options: MapOptions(
//           center: _currentLocation!,
//           zoom: 15.0,
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             userAgentPackageName: 'com.example.resqtrack1',
//           ),
//           MarkerLayer(
//             markers: [
//               Marker(
//                 point: _currentLocation!,
//                 width: 40,
//                 height: 40,
//                 child: const Icon(
//                   Icons.location_pin,
//                   color: Colors.red,
//                   size: 40,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           if (_currentLocation != null) {
//             _mapController.move(_currentLocation!, 15.0);
//           }
//         },
//         child: const Icon(Icons.my_location),
//       ),
//     );
//   }
// }