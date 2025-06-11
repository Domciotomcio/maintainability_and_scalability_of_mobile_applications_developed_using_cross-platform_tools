import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

// Module for Camera feature
class CameraModule extends StatefulWidget {
  const CameraModule({Key? key}) : super(key: key);

  @override
  State<CameraModule> createState() => _CameraModuleState();
}

class _CameraModuleState extends State<CameraModule> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  XFile? _capturedImage;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.isNotEmpty ? cameras.first : null;
      if (camera == null) {
        setState(() => _error = 'No camera found.');
        return;
      }
      _controller = CameraController(camera, ResolutionPreset.medium);
      _initializeControllerFuture = _controller!.initialize();
      setState(() {});
    } catch (e) {
      setState(() => _error = 'Camera error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      setState(() {
        _capturedImage = image;
      });
    } catch (e) {
      setState(() => _error = 'Capture error: $e');
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
              'Camera',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red))
            else if (_controller == null || _initializeControllerFuture == null)
              const Text('Initializing camera...')
            else
              FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: CameraPreview(_controller!),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _captureImage,
                          child: const Text('Capture Image'),
                        ),
                        if (_capturedImage != null) ...[
                          const SizedBox(height: 8),
                          Image.file(
                            File(_capturedImage!.path),
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
