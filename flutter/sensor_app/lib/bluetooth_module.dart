import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// Module for Bluetooth feature
class BluetoothModule extends StatefulWidget {
  const BluetoothModule({Key? key}) : super(key: key);

  @override
  State<BluetoothModule> createState() => _BluetoothModuleState();
}

class _BluetoothModuleState extends State<BluetoothModule> {
  List<BluetoothDevice> _devices = [];
  bool _scanning = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() async {
    setState(() {
      _scanning = true;
      _devices = [];
      _error = null;
    });
    try {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
      FlutterBluePlus.scanResults.listen((results) {
        setState(() {
          _devices = results.map((r) => r.device).toList();
        });
      });
      await Future.delayed(const Duration(seconds: 4));
      FlutterBluePlus.stopScan();
      setState(() {
        _scanning = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Bluetooth error: $e';
        _scanning = false;
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
              'Bluetooth',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red))
            else if (_scanning)
              const Text('Scanning for devices...')
            else if (_devices.isEmpty)
              const Text('No devices found.')
            else ...[
              const Text('Devices:'),
              ..._devices.map(
                (d) => Text(d.name.isNotEmpty ? d.name : d.id.toString()),
              ),
            ],
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _scanning ? null : _startScan,
              child: const Text('Rescan'),
            ),
          ],
        ),
      ),
    );
  }
}
