import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../widgets/message_validate_barcode.dart';
import '../screens/data_register.dart';

class ScanBarcode extends StatefulWidget {
  final String? vinText;

  const ScanBarcode({super.key, this.vinText});

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> 
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool _isScanned = false;
  MobileScannerController? _controller;
  late AnimationController _laserController;
  bool _flashOn = false;
  Rect? _scanRect;
  bool _cameraInitialized = false;
  bool _shouldStopDetection = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
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
    _controller?.dispose();
    _controller = null;
    _laserController.dispose();
    super.dispose();
  }

  void _initializeCamera() {
    try {
      _controller = MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        torchEnabled: false,
        returnImage: false,
      );
      
      _controller!.start().then((_) {
        if (mounted) {
          setState(() {
            _cameraInitialized = true;
            _shouldStopDetection = false;
          });
        }
      }).catchError((e) {
        print("Error starting camera: $e");
        if (mounted) {
          setState(() {
            _cameraInitialized = false;
          });
        }
      });
    } catch (e) {
      print("Error initializing camera: $e");
      if (mounted) {
        setState(() {
          _cameraInitialized = false;
        });
      }
    }
  }

  Future<void> _stopCamera() async {
    try {
      if (_controller != null) {
        await _controller!.stop();
      }
    } catch (e) {
      print("Error stopping camera: $e");
    }
  }

  Future<void> _restartCamera() async {
    try {
      await _stopCamera();
      await Future.delayed(const Duration(milliseconds: 300));
      if (_controller != null && mounted) {
        await _controller!.start();
      }
    } catch (e) {
      print("Error restarting camera: $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      setState(() {
        _scanRect = Rect.fromCenter(
          center: Offset(screenSize.width / 2, screenSize.height / 2 - 60),
          width: screenSize.width * 0.9,
          height: screenSize.height * 0.2,
        );
      });
    });
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || _shouldStopDetection) return;
    await _controller!.toggleTorch();
    setState(() {
      _flashOn = !_flashOn;
    });
  }

  bool _isWithinScanRect(List<Offset> corners) {
    if (_scanRect == null) return false;

    final avgX = corners.map((p) => p.dx).reduce((a, b) => a + b) / corners.length;
    final avgY = corners.map((p) => p.dy).reduce((a, b) => a + b) / corners.length;
    final center = Offset(avgX, avgY);

    return _scanRect!.contains(center);
  }

  void _processScannedCode(String code) {
    if (_isScanned || _shouldStopDetection) return;
    
    setState(() {
      _isScanned = true;
      _shouldStopDetection = true;
    });
    
    _stopCamera();
    
    if (code.length == 20) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => MessageValidateBarcode(
          barcodeText: code,
          onTryAgain: () {
            setState(() {
              _isScanned = false;
              _shouldStopDetection = false;
            });
            _restartCamera();
          },
          onAdd: () => _goToDataRegister(code),
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            'Escaneo inválido',
            style: TextStyle(color: Colors.blue[800]),
          ),
          content: const Text('El código debe tener exactamente 20 caracteres.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isScanned = false;
                  _shouldStopDetection = false;
                });
                _restartCamera();
              },
              child: Text('Reintentar', style: TextStyle(color: Colors.blue[800])),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final scanRect = _scanRect ?? Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 2 - 60),
      width: screenSize.width * 0.9,
      height: screenSize.height * 0.2,
    );

    return Scaffold(
      appBar: AppBar(
        title: widget.vinText != null
            ? const Text('Escaneo SIM')
            : const Text('Escaneo VIN'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: !_cameraInitialized
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Stack(
              children: [
                if (!_shouldStopDetection)
                MobileScanner(
                  controller: _controller!,
                  fit: BoxFit.cover,
                  onDetect: (capture) {
                    if (_isScanned || _scanRect == null || _shouldStopDetection) return;

                    for (final barcode in capture.barcodes) {
                      final code = barcode.rawValue;
                      final corners = barcode.corners;
                      if (code != null && corners != null && corners.length == 4) {
                        if (_isWithinScanRect(corners)) {
                          _processScannedCode(code);
                          break;
                        }
                      }
                    }
                  },
                ),

                Positioned.fill(
                  child: CustomPaint(
                    painter: ScannerOverlayPainter(scanRect: scanRect),
                  ),
                ),

                // Esquinas del recuadro de escaneo
                Positioned.fill(
                  child: CustomPaint(
                    painter: ScannerCornersPainter(
                      scanRect: scanRect,
                      borderRadius: 16,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),

                if (!_shouldStopDetection)
                AnimatedBuilder(
                  animation: _laserController,
                  builder: (context, child) {
                    return Positioned(
                      top: scanRect.top + (scanRect.height * _laserController.value),
                      left: scanRect.left,
                      child: Container(
                        width: scanRect.width,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.lightBlueAccent,
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.lightBlueAccent.withValues(alpha: 0.8),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Instrucción bajo el recuadro
                if (!_shouldStopDetection)
                Positioned(
                  top: scanRect.bottom + 20,
                  left: 24,
                  right: 24,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.barcode_reader,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              widget.vinText != null
                                  ? 'Coloca el código de barras de la SIM en el recuadro'
                                  : 'Coloca el código de barras en el recuadro',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (!_shouldStopDetection)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: _toggleFlash,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: _flashOn
                              ? Colors.amber
                              : Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _flashOn ? Icons.flash_on : Icons.flash_off,
                              color: _flashOn ? Colors.black87 : Colors.white,
                              size: 26,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _flashOn ? 'Linterna encendida' : 'Linterna',
                              style: TextStyle(
                                color: _flashOn ? Colors.black87 : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                if (_shouldStopDetection)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Text(
                      _isScanned ? 'Escaneo completado' : 'Escaneo detenido',
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

  void _goToDataRegister(String simText) {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DataRegister(
          vinText: widget.vinText ?? "",
          simText: simText,
          extractedText: simText,
        ),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _isScanned = false;
          _shouldStopDetection = false;
        });
        _restartCamera();
      }
    });
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Rect scanRect;

  ScannerOverlayPainter({
    required this.scanRect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.5);
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    
    final holePath = Path()
      ..addRRect(RRect.fromRectAndRadius(scanRect, const Radius.circular(16)));
    
    final overlay = Path.combine(PathOperation.difference, backgroundPath, holePath);
    canvas.drawPath(overlay, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) =>
      oldDelegate.scanRect != scanRect;
}

// Dibuja solo las cuatro esquinas del recuadro de escaneo
class ScannerCornersPainter extends CustomPainter {
  final Rect scanRect;
  final double borderRadius;
  final Color color;

  ScannerCornersPainter({
    required this.scanRect,
    required this.borderRadius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final r = borderRadius;
    const l = 36.0; // largo de cada brazo
    final rect = scanRect;

    Path esquina(Offset corner, double dx, double dy) {
      // dx, dy indican hacia dónde se extienden los brazos (±1)
      return Path()
        ..moveTo(corner.dx, corner.dy + dy * (r + l))
        ..lineTo(corner.dx, corner.dy + dy * r)
        ..quadraticBezierTo(
          corner.dx,
          corner.dy,
          corner.dx + dx * r,
          corner.dy,
        )
        ..lineTo(corner.dx + dx * (r + l), corner.dy);
    }

    canvas.drawPath(esquina(rect.topLeft, 1, 1), paint);
    canvas.drawPath(esquina(rect.topRight, -1, 1), paint);
    canvas.drawPath(esquina(rect.bottomLeft, 1, -1), paint);
    canvas.drawPath(esquina(rect.bottomRight, -1, -1), paint);
  }

  @override
  bool shouldRepaint(covariant ScannerCornersPainter oldDelegate) =>
      oldDelegate.scanRect != scanRect ||
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.color != color;
}
