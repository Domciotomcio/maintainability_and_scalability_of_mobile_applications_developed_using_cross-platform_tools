import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';

// Module for Gyroscope feature
class GyroscopeModule extends StatefulWidget {
  const GyroscopeModule({Key? key}) : super(key: key);

  @override
  State<GyroscopeModule> createState() => _GyroscopeModuleState();
}

class _GyroscopeModuleState extends State<GyroscopeModule> {
  GyroscopeEvent? _event;
  late final Stream<GyroscopeEvent> _stream;

  @override
  void initState() {
    super.initState();
    _stream = gyroscopeEvents;
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
              'Gyroscope',
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
