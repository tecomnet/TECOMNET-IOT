import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  _ScanQrState createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQR> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras[0],
      ResolutionPreset.medium,
    );
    await _cameraController.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _scanQrCode() async {
    setState(() {
      _isProcessing = true;
    });

    // Aquí se implementaría la lógica para escanear QR...

    await Future.delayed(const Duration(seconds: 1)); // Simulación

    setState(() {
      _isProcessing = false;
    });

    // Aquí podrías mostrar un diálogo con el resultado del QR
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneo de QR'),
      ),
      body: _isCameraInitialized
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CameraPreview(_cameraController),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _scanQrCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _isProcessing
                            ? const CircularProgressIndicator()
                            : const Text('Escanear', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
