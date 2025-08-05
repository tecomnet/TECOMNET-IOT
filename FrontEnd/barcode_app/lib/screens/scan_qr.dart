import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:barcode_app/widgets/message_validate_qr.dart';
import 'package:barcode_app/screens/scan_sim.dart';
import 'package:audioplayers/audioplayers.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  bool _isScanning = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _flashOn = false;
  Rect? _scanRect;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      const scannerSize = 250.0;
      final topMargin = size.height * 0.2;
      setState(() {
        _scanRect = Rect.fromCenter(
          center: Offset(size.width / 2, topMargin + scannerSize / 2),
          width: scannerSize,
          height: scannerSize,
        );
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    _controller!.resumeCamera();

    _controller!.scannedDataStream.listen((scanData) {
      if (_isScanning) {
        _isScanning = false;
        _controller?.pauseCamera();
        _playSuccessSound();

        if (scanData.code != null && scanData.code!.isNotEmpty) {
          _showScanResultDialog(scanData.code!);
        }
      }
    });
  }

  Future<void> _playSuccessSound() async {
    await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
  }

  Future<void> _toggleFlash() async {
    await _controller?.toggleFlash();
    setState(() {
      _flashOn = !_flashOn;
    });
  }

  void _showScanResultDialog(String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => MessageValidateQR(
        title: "Escaneo exitoso",
        content: result,
        onTryAgain: _resetScanner,
        onAdd: () => _goToScanSim(result),
      ),
    );
  }

  void _resetScanner() {
    setState(() {
      _isScanning = true;
    });
    _controller?.resumeCamera();
  }

  void _goToScanSim(String scannedText) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanSim(vinText: scannedText),
      ),
    ).then((_) {
      _controller?.resumeCamera();
      setState(() {
        _isScanning = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const scannerSize = 250.0;
    final topMargin = size.height * 0.2;
    final scanRect = _scanRect ?? Rect.fromCenter(
      center: Offset(size.width / 2, topMargin + scannerSize / 2),
      width: scannerSize,
      height: scannerSize,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneo de QR'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.transparent,
              borderRadius: 0,
              borderLength: 0,
              borderWidth: 0,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          
          // Overlay oscuro con recorte
          Positioned.fill(
            child: CustomPaint(
              painter: ScannerOverlayPainter(
                scanRect: scanRect,
                borderRadius: 24,
              ),
            ),
          ),
          
          // Marco de escaneo
          Positioned(
            top: topMargin,
            left: (size.width - scannerSize) / 2,
            child: Container(
              width: scannerSize,
              height: scannerSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.8), 
                  width: 2
                ),
              ),
            ),
          ),

          // Instrucciones
          Positioned(
            top: topMargin + scannerSize + 30,
            width: size.width,
            child: const Text(
              'Enfoca el código QR dentro del marco',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          
          // Botón de flash
          Positioned(
            top: 70,
            right: 20,
            child: GestureDetector(
              onTap: _toggleFlash,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  _flashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Rect scanRect;
  final double borderRadius;

  ScannerOverlayPainter({
    required this.scanRect,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.5);
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    
    final holePath = Path()
      ..addRRect(RRect.fromRectAndRadius(scanRect, Radius.circular(borderRadius)));
    
    final overlay = Path.combine(PathOperation.difference, backgroundPath, holePath);
    canvas.drawPath(overlay, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) =>
      oldDelegate.scanRect != scanRect || oldDelegate.borderRadius != borderRadius;
}