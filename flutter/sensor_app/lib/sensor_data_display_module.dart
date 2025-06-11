import 'package:flutter/material.dart';
import 'accelerometer_module.dart';
import 'gyroscope_module.dart';
import 'magnetometer_module.dart';
import 'gps_module.dart';
import 'compass_module.dart';
import 'light_sensor_module.dart';
import 'proximity_sensor_module.dart';
import 'microphone_module.dart';
import 'bluetooth_module.dart';
import 'camera_module.dart';

// Module for displaying real-time sensor data from all sensors
class SensorDataDisplayModule extends StatelessWidget {
  const SensorDataDisplayModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        AccelerometerModule(),
        GyroscopeModule(),
        MagnetometerModule(),
        GPSModule(),
        CompassModule(),
        LightSensorModule(),
        ProximitySensorModule(),
        MicrophoneModule(),
        BluetoothModule(),
        CameraModule(),
        // Add other sensor modules here
      ],
    );
  }
}
