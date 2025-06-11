import 'package:flutter/material.dart';
import 'sensor_data_display_module.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Flutter Sensor App'),
                SizedBox(height: 20),
                SensorDataDisplayModule(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
