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

class _ScanBarcodeState extends State<ScanBarcode> with SingleTickerProviderStateMixin {
  bool _isScanned = false;
  late final MobileScannerController _controller;
  late AnimationController _laserController;
  bool _flashOn = false;
  Rect? _scanRect;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
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

  @override
  void dispose() {
    _controller.dispose();
    _laserController.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    await _controller.toggleTorch();
    setState(() {
      _flashOn = !_flashOn;
    });
  }

  bool _isWithinScanRect(Offset point) {
    if (_scanRect == null) return false;
    return _scanRect!.contains(point);
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
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            fit: BoxFit.cover,
            onDetect: (capture) {
              if (_isScanned || _scanRect == null) return;

              for (final barcode in capture.barcodes) {
                final code = barcode.rawValue;
                if (code != null) {
                  final barcodeCenter = Offset(
                    (barcode.corners[0].dx + barcode.corners[2].dx) / 2,
                    (barcode.corners[0].dy + barcode.corners[2].dy) / 2,
                  );

                  if (_isWithinScanRect(barcodeCenter)) {
                    setState(() {
                      _isScanned = true;
                    });
                    
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => MessageValidateBarcode(
                        barcodeText: code,
                        onTryAgain: () {
                          setState(() {
                            _isScanned = false;
                          });
                        },
                        onAdd: () => _goToDataRegister(code),
                      ),
                    );
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
              ),
            ),
          ),
          
          Positioned.fromRect(
            rect: scanRect,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
                  width: 2,
                ),
              ),
            ),
          ),
          
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
          
          Positioned(
            top: scanRect.bottom + 20,
            left: 0,
            right: 0,
            child: Text(
              '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
          
          // Botón de flash más arriba (cerca del borde superior)
          Positioned(
            top: 70, // Posición fija cerca del borde superior
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
      setState(() {
        _isScanned = false;
      });
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