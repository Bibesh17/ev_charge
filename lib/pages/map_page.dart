/*import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _initialPosition = LatLng(26.4525, 87.2718);
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _initialPosition,
              zoom: 10.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Search box and icons
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        TextField(
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Your Location',
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 145, 145, 145),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(205, 221, 169, 0.651)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.filter_alt, color: Colors.green),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Circular buttons on the right side
                  Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.location_pin,
                              color: Colors.green),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.phone, color: Colors.green),
                          onPressed: () {},
                        ),
                      ],
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
}*/