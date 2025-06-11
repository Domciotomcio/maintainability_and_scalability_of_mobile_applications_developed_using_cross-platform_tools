import 'package:flutter/material.dart';
import 'package:light_sensor/light_sensor.dart';

// Module for Light Sensor feature
class LightSensorModule extends StatefulWidget {
  const LightSensorModule({Key? key}) : super(key: key);

  @override
  State<LightSensorModule> createState() => _LightSensorModuleState();
}

class _LightSensorModuleState extends State<LightSensorModule> {
  int? _lux;
  String? _error;

  @override
  void initState() {
    super.initState();
    LightSensor.luxStream().listen(
      (lux) {
        setState(() {
          _lux = lux;
          _error = null;
        });
      },
      onError: (e) {
        setState(() {
          _error = 'Error: $e';
        });
      },
    );
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
              'Light Sensor',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red))
            else if (_lux == null)
              const Text('Waiting for data...')
            else
              Text('Ambient Light: $_lux lux'),
          ],
        ),
      ),
    );
  }
}
