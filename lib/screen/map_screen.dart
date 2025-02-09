import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MosqueMapScreen extends StatefulWidget {
  const MosqueMapScreen({super.key});

  @override
  State<MosqueMapScreen> createState() => _MosqueMapScreenState();
}

class _MosqueMapScreenState extends State<MosqueMapScreen> {
  late GoogleMapController _mapController;
  final LatLng _initialPosition = LatLng(24.0, 45.0); // Center of Saudi Arabia
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchMosqueLocations();
  }

  Future<void> _fetchMosqueLocations() async {
    const String apiUrl = 'https://your-backend-api.com/mosques';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _markers = Set<Marker>.from(
          data['mosques'].map((mosque) {
            return Marker(
              markerId: MarkerId(mosque['name']),
              position: LatLng(mosque['lat'], mosque['lng']),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              infoWindow: InfoWindow(title: mosque['name']),
            );
          }),
        );
      });
    } else {
      throw Exception('Failed to load mosque locations');
    }
  }

  void _zoomIn() {
    _mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 6.0,
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _zoomIn,
                  child: const Icon(Icons.add),
                  mini: true,
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  child: const Icon(Icons.remove),
                  mini: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 