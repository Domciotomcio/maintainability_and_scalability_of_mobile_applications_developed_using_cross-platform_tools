import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

// Module for Compass feature
class CompassModule extends StatefulWidget {
  const CompassModule({Key? key}) : super(key: key);

  @override
  State<CompassModule> createState() => _CompassModuleState();
}

class _CompassModuleState extends State<CompassModule> {
  double? _heading;

  @override
  void initState() {
    super.initState();
    FlutterCompass.events?.listen((event) {
      setState(() {
        _heading = event.heading;
      });
    });
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
              'Compass',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _heading == null
                ? const Text('Waiting for data...')
                : Text('Heading: ${_heading!.toStringAsFixed(2)}°'),
          ],
        ),
      ),
    );
  }
}
