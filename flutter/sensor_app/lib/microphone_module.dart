import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'dart:async';

// Module for Microphone feature
class MicrophoneModule extends StatefulWidget {
  const MicrophoneModule({Key? key}) : super(key: key);

  @override
  State<MicrophoneModule> createState() => _MicrophoneModuleState();
}

class _MicrophoneModuleState extends State<MicrophoneModule> {
  bool _isRecording = false;
  double? _meanDecibel;
  double? _maxDecibel;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  final NoiseMeter _noiseMeter = NoiseMeter();

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _onData(NoiseReading noiseReading) {
    setState(() {
      _meanDecibel = noiseReading.meanDecibel;
      _maxDecibel = noiseReading.maxDecibel;
    });
  }

  void _onError(Object error) {
    setState(() {
      _isRecording = false;
    });
  }

  void _start() async {
    try {
      _noiseSubscription = _noiseMeter.noise.listen(_onData, onError: _onError);
      setState(() => _isRecording = true);
    } catch (err) {
      setState(() => _isRecording = false);
    }
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
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
              'Microphone',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (!_isRecording)
              const Text('Microphone not recording or permission denied.')
            else if (_meanDecibel == null)
              const Text('Waiting for audio data...')
            else ...[
              Text('Mean Decibel: ${_meanDecibel!.toStringAsFixed(2)} dB'),
              Text('Max Decibel: ${_maxDecibel!.toStringAsFixed(2)} dB'),
            ],
          ],
        ),
      ),
    );
  }
}
