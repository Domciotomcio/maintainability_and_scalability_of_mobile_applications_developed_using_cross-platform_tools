import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// Module for GPS feature
class GPSModule extends StatefulWidget {
  const GPSModule({Key? key}) : super(key: key);

  @override
  State<GPSModule> createState() => _GPSModuleState();
}

class _GPSModuleState extends State<GPSModule> {
  Position? _position;
  String? _error;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = 'Location services are disabled.';
        });
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = 'Location permissions are denied.';
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = 'Location permissions are permanently denied.';
        });
        return;
      }
      Geolocator.getPositionStream().listen((Position position) {
        setState(() {
          _position = position;
          _error = null;
        });
      });
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GPS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red))
            else if (_position == null)
              const Text('Waiting for location...')
            else ...[
              Text('Latitude: ${_position!.latitude.toStringAsFixed(6)}'),
              Text('Longitude: ${_position!.longitude.toStringAsFixed(6)}'),
              Text('Accuracy: ${_position!.accuracy.toStringAsFixed(2)} m'),
            ],
          ],
        ),
      ),
    );
  }
}
