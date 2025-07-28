import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:barcode_app/widgets/message_validate_qr.dart';
import 'package:barcode_app/screens/data_register.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  bool _isScanning = true; // ✅ Se inicia automáticamente

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    _controller!.resumeCamera(); // ✅ Asegura que la cámara arranque

    _controller!.scannedDataStream.listen((scanData) {
      if (_isScanning) {
        _isScanning = false; // Detener escaneo automáticamente
        _controller?.pauseCamera(); // Pausar cámara

        if (scanData.code != null && scanData.code!.isNotEmpty) {
          _showScanResultDialog(scanData.code!);
        }
      }
    });
  }

  void _showScanResultDialog(String result) {
    showDialog(
      context: context,
      builder: (_) => MessageValidateQR(
        title: "Resultado",
        content: result,
        onTryAgain: _resetScanner,
        onAdd: () => _goToDataRegister(result),
      ),
    );
  }


  void _resetScanner() {
    setState(() {
      _isScanning = true;
    });
    _controller?.pauseCamera();
    Future.delayed(const Duration(milliseconds: 300), () {
      _controller?.resumeCamera();
    });
  }

void _goToDataRegister(String scannedText) {
  // Cerrar cualquier diálogo abierto antes de navegar
  Navigator.of(context).pop(); // Esto cierra el diálogo actual

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DataRegister(extractedText: scannedText),
    ),
  ).then((_) {
    // Reanudar la cámara cuando regresamos
    _controller?.resumeCamera();
    setState(() {
      _isScanning = true;
    });
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escaneo de QR')),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 12,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      ),
    );
  }
}
