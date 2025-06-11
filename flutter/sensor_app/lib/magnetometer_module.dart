import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';

// Module for Magnetometer feature
class MagnetometerModule extends StatefulWidget {
  const MagnetometerModule({Key? key}) : super(key: key);

  @override
  State<MagnetometerModule> createState() => _MagnetometerModuleState();
}

class _MagnetometerModuleState extends State<MagnetometerModule> {
  MagnetometerEvent? _event;
  late final Stream<MagnetometerEvent> _stream;

  @override
  void initState() {
    super.initState();
    _stream = magnetometerEvents;
    _stream.listen((event) {
      setState(() {
        _event = event;
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
              'Magnetometer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _event == null
                ? const Text('Waiting for data...')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('X: ${_event!.x.toStringAsFixed(3)}'),
                      Text('Y: ${_event!.y.toStringAsFixed(3)}'),
                      Text('Z: ${_event!.z.toStringAsFixed(3)}'),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
