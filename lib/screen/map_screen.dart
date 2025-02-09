import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

import 'package:logger/logger.dart';

class MosqueMapScreen extends StatefulWidget {
  const MosqueMapScreen({super.key});

  @override
  State<MosqueMapScreen> createState() => _MosqueMapScreenState();
}

class _MosqueMapScreenState extends State<MosqueMapScreen> {
  late GoogleMapController _mapController;
  final LatLng _initialPosition = LatLng(3.8480, 11.5021);
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchMosqueLocations();
  }


Future<void> _fetchMosqueLocations() async {
  try {
    final log = Logger();
    log.d('Loading mosques.json from assets');
    
    final String response = await rootBundle.loadString('assets/mosque.json');
    log.d('JSON loaded successfully');
    
    final data = jsonDecode(response);
    log.d('JSON parsed successfully');
    
    if (data['mosques'] == null) {
      log.e('No mosques found in JSON data');
      return;
    }
    
    log.d('Found ${data['mosques'].length} mosques in JSON');
    
    setState(() {
      _markers = Set<Marker>.from(
        data['mosques'].map((mosque) {
          log.d('Creating marker for ${mosque['name']} at (${mosque['lat']}, ${mosque['lng']})');
          return Marker(
            markerId: MarkerId(mosque['name']),
            position: LatLng(mosque['lat'], mosque['lng']),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(title: mosque['name']),
          );
        }),
      );
      log.d('Total markers created: ${_markers.length}');
    });
  } catch (e) {
    Logger().e('Error loading mosques: $e');
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
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            mapToolbarEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12.0,
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