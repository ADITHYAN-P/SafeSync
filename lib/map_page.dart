import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:safesync/analysis_page.dart';
import 'package:safesync/profile_page.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class LiveMap extends StatefulWidget {
  @override
  _LiveMapState createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  LatLng _currentLocation = LatLng(0, 0);
  MapController _mapController = MapController();
  int _initSpeed = 0;
  final channel = IOWebSocketChannel.connect('ws://192.168.72.243:80/ws');

  void _changeSpeed(int speed) {
    setState(() {
      _initSpeed = speed;
    });
    print("speed-$_initSpeed");
  }

  void _updateLocation(double latitude, double longitude) {
    setState(() {
      _currentLocation = LatLng(latitude, longitude);
    });
    _mapController.move(_currentLocation, 15.0, offset: Offset(10, 10));
    print('Location updated - Latitude: $latitude, Longitude: $longitude');
  }

  @override
  void initState() {
    super.initState();
    channel.stream.listen((data) {
      try {
        Map<String, dynamic> jsonData = json.decode(data);
        double latitude = jsonData['latitude'];
        double longitude = jsonData['longitude'];
        double speed = jsonData['speed'];
        _updateLocation(latitude, longitude);
        _changeSpeed(speed.toInt());
      } catch (e) {
        print('Error parsing data: $e');
      }
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Live Tracking',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _buildMap(),
                Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Speed: $_initSpeed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AnalysisPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: const Center(
                      child: Text(
                        'Analysis',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: const Center(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentLocation,
        initialZoom: 15.0,
        keepAlive: true,
        interactionOptions: InteractionOptions(
          enableMultiFingerGestureRace: true,
          enableScrollWheel: true,
          pinchZoomThreshold: 15.0,
          rotationThreshold: 20.0,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 40.0,
              height: 40.0,
              point: _currentLocation,
              child: Icon(Icons.location_on, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
