import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:Scannet_Tecomnet/widgets/message_validate_qr.dart';
import 'package:Scannet_Tecomnet/screens/scan_sim.dart';
import 'package:image_picker/image_picker.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> 
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  MobileScannerController? _controller;
  bool _isScanning = true;
  bool _flashOn = false;
  Rect? _scanRect;
  bool _cameraInitialized = false;
  final ImagePicker _picker = ImagePicker();
  bool _isProcessingImage = false;
  bool _dialogOpen = false;
  double _zoomLevel = 0.7;
  late AnimationController _laserController;
  late Animation<double> _animation;
  bool _shouldStopDetection = false; // Nuevo flag para controlar la detección

  // CONSTANTES MODIFICADAS
  static const double scannerSize = 200.0;
  static const double widthMultiplier = 0.9;
  static const double heightMultiplier = 2.0;
  static const double topMarginRatio = 0.3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0, end: 1).animate(_laserController);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _restartCamera();
    } else if (state == AppLifecycleState.paused) {
      _stopCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _laserController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _initializeCamera() {
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
      returnImage: false,
    );
    
    _startCamera();
  }

  Future<void> _startCamera() async {
    try {
      await _controller?.start();
      await _controller?.setZoomScale(_zoomLevel);
      if (mounted) {
        setState(() {
          _cameraInitialized = true;
          _shouldStopDetection = false; // Reset flag
        });
      }
    } catch (e) {
      debugPrint('Error starting camera: $e');
    }
  }

  Future<void> _stopCamera() async {
    try {
      await _controller?.stop();
    } catch (e) {
      debugPrint('Error stopping camera: $e');
    }
  }

  Future<void> _restartCamera() async {
    try {
      await _stopCamera();
      await Future.delayed(const Duration(milliseconds: 300));
      await _startCamera();
    } catch (e) {
      debugPrint('Error restarting camera: $e');
    }
  }

  Rect _computeScanRect(Size size) {
    final topMargin = size.height * topMarginRatio;
    return Rect.fromCenter(
      center: Offset(size.width / 2, topMargin + scannerSize / 2),
      width: size.width * widthMultiplier,
      height: scannerSize * heightMultiplier,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        _scanRect = _computeScanRect(size);
      });
    });
  }

  double _calculateQrSize(List<Offset> corners) {
    final width = (corners[1].dx - corners[0].dx).abs();
    final height = (corners[2].dy - corners[0].dy).abs();
    return (width + height) / 2;
  }

  bool _isBarcodeInScanArea(Barcode barcode) {
    if (_scanRect == null) return false;
    
    double sumX = 0;
    double sumY = 0;
    for (Offset corner in barcode.corners) {
      sumX += corner.dx;
      sumY += corner.dy;
    }
    final centerX = sumX / barcode.corners.length;
    final centerY = sumY / barcode.corners.length;
    final qrCenter = Offset(centerX, centerY);

    return _scanRect!.contains(qrCenter);
  }

  void _adjustZoomAutomatically(double qrSize) {
    if (!_cameraInitialized || _dialogOpen || _shouldStopDetection) return;
    
    double newZoom = _zoomLevel;
    
    if (qrSize < 100) {
      newZoom = _zoomLevel < 0.9 ? _zoomLevel + 0.1 : 1.0;
    } else if (qrSize > 200) {
      newZoom = _zoomLevel > 0.3 ? _zoomLevel - 0.1 : 0.1;
    } else if (qrSize < 150) {
      newZoom = _zoomLevel < 0.95 ? _zoomLevel + 0.05 : 1.0;
    } else if (qrSize > 180) {
      newZoom = _zoomLevel > 0.4 ? _zoomLevel - 0.05 : 0.4;
    }
    
    if (newZoom != _zoomLevel) {
      _controller!.setZoomScale(newZoom).then((_) {
        _zoomLevel = newZoom;
      }).catchError((e) {
        debugPrint('Error adjusting zoom: $e');
      });
    }
  }

  void _processScannedCode(String code) {
    if (!_isScanning || _dialogOpen || _shouldStopDetection) return;
    
    if (code.length != 17) {
      _showInvalidQRDialog();
      return;
    }
    
    setState(() {
      _isScanning = false;
      _dialogOpen = true;
      _shouldStopDetection = true; // Detener nuevas detecciones
    });
    
    // Detener la cámara inmediatamente
    _stopCamera();
    
    _showScanResultDialog(code);
  }

  void _showInvalidQRDialog() {
    setState(() => _dialogOpen = true);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("Código QR inválido", style: TextStyle(color: Colors.blue[800])),
        content: const Text("El código QR debe contener exactamente 17 caracteres."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetScanner();
            },
            child: Text('Reintentar', style: TextStyle(color: Colors.blue[800])),
          ),
        ],
      ),
    ).then((_) {
      setState(() => _dialogOpen = false);
    });
  }

  Future<void> _scanQRFromImage() async {
    if (_dialogOpen || _shouldStopDetection) return;
    
    setState(() => _isProcessingImage = true);
    
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        final BarcodeCapture? result = await _controller?.analyzeImage(image.path);
        
        if (result != null && result.barcodes.isNotEmpty) {
          final barcode = result.barcodes.first;
          if (barcode.rawValue != null) {
            if (barcode.rawValue!.length == 17) {
              _processScannedCode(barcode.rawValue!);
            } else {
              _showInvalidQRDialog();
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se detectó código QR en la imagen')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error scanning image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isProcessingImage = false);
    }
  }

  Future<void> _toggleFlash() async {
    if (!_cameraInitialized || _dialogOpen || _shouldStopDetection) return;
    
    try {
      await _controller?.toggleTorch();
      setState(() => _flashOn = !_flashOn);
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  void _showScanResultDialog(String result) {
    setState(() => _dialogOpen = true);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => MessageValidateQR(
        title: "Escaneo exitoso",
        content: result,
        onTryAgain: _resetScanner,
        onAdd: () => _goToScanSim(result),
      ),
    ).then((_) {
      setState(() => _dialogOpen = false);
    });
  }

  void _resetScanner() {
    if (!mounted) return;
    
    setState(() {
      _isScanning = true;
      _shouldStopDetection = false; // Permitir nuevas detecciones
    });
    
    _restartCamera();
  }

  void _goToScanSim(String scannedText) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanSim(vinText: scannedText),
      ),
    ).then((_) {
      if (mounted) {
        _resetScanner();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanRect = _scanRect ?? _computeScanRect(size);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneo de QR'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: _isProcessingImage || _dialogOpen || _shouldStopDetection 
                ? null 
                : _scanQRFromImage,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_cameraInitialized && !_shouldStopDetection)
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (!_isScanning || _dialogOpen || _shouldStopDetection) return;
              
              for (final barcode in capture.barcodes) {
                if (barcode.rawValue != null && barcode.corners != null) {
                  final qrSize = _calculateQrSize(barcode.corners!);
                  _adjustZoomAutomatically(qrSize);
                  
                  if (_isBarcodeInScanArea(barcode)) {
                    if (barcode.rawValue!.length == 17) {
                      _processScannedCode(barcode.rawValue!);
                    } else {
                      _showInvalidQRDialog();
                    }
                    break;
                  }
                }
              }
            },
          ),
          
          Positioned.fill(
            child: CustomPaint(
              painter: ScannerOverlayPainter(
                scanRect: scanRect,
                borderRadius: 24,
              ),
            ),
          ),
          
          Positioned(
            top: scanRect.top,
            left: scanRect.left,
            child: Container(
              width: scanRect.width,
              height: scanRect.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.8), 
                  width: 2
                ),
              ),
            ),
          ),

          // Línea roja animada
          if (_cameraInitialized && !_shouldStopDetection)
          AnimatedBuilder(
            animation: _laserController,
            builder: (context, child) {
              return Positioned(
                top: scanRect.top + (scanRect.height * _animation.value),
                left: scanRect.left,
                child: Container(
                  width: scanRect.width,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.red.shade700,
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.8),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          if (_cameraInitialized && !_shouldStopDetection)
          Positioned(
            top: 70,
            right: 20,
            child: GestureDetector(
              onTap: _dialogOpen ? null : _toggleFlash,
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

          if (!_cameraInitialized)
          const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
          
          if (_isProcessingImage)
          Container(
            color: Colors.black.withOpacity(0.7),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    'Procesando imagen...',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          
          // Mensaje cuando la detección está detenida
          if (_shouldStopDetection)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Text(
                'Escaneo completado',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.6);
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