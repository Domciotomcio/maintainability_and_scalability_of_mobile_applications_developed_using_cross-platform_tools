import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'dart:async';

// Module for Proximity Sensor feature
class ProximitySensorModule extends StatefulWidget {
  const ProximitySensorModule({Key? key}) : super(key: key);

  @override
  State<ProximitySensorModule> createState() => _ProximitySensorModuleState();
}

class _ProximitySensorModuleState extends State<ProximitySensorModule> {
  bool _isNear = false;
  StreamSubscription<dynamic>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = event > 0;
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
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
              'Proximity Sensor',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(_isNear ? 'Object detected nearby' : 'No object nearby'),
          ],
        ),
      ),
    );
  }
}
