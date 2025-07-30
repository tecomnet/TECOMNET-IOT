import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../widgets/message_validate_barcode.dart';

class ScanBarcode extends StatefulWidget {
  const ScanBarcode({super.key});

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> with SingleTickerProviderStateMixin {
  // Variable para controlar si ya se escaneó un código para evitar múltiples escaneos
  bool _isScanned = false;

  // Controlador para la cámara y escaneo del código de barras
  late final MobileScannerController _controller;

  // Controlador para animaciones (línea que se mueve en el área de escaneo)
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Inicializamos el controlador del escáner
    _controller = MobileScannerController();

    // Inicializamos y arrancamos la animación de la línea que se mueve en el área de escaneo
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Se repite adelante y atrás
  }

  @override
  void dispose() {
    // Liberamos los controladores para evitar fugas de memoria
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tamaño de la pantalla para definir el área de escaneo
    final screenSize = MediaQuery.of(context).size;

    // Definimos el rectángulo donde el usuario debe colocar el código de barras
    final scanRect = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 2 - 60),
      width: screenSize.width * 0.9,
      height: screenSize.height * 0.15,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Escaneo con barcode')),
      body: Stack(
        children: [
          // Widget principal que captura y detecta códigos de barras
          MobileScanner(
            controller: _controller,
            fit: BoxFit.cover,
            onDetect: (capture) {
              // Si ya se escaneó un código, no hacemos nada para evitar repetir
              if (_isScanned) return;

              for (final barcode in capture.barcodes) {
                final code = barcode.rawValue;
                if (code != null) {
                  setState(() {
                    _isScanned = true; // Marcamos que ya escaneamos un código
                  });

                  // Mostramos diálogo con el resultado del código escaneado
                  showDialog(
                    context: context,
                    barrierDismissible: false, // No permitir cerrar tocando fuera
                    builder: (context) => MessageValidateBarcode(
                      barcodeText: code,
                      onTryAgain: () {
                        setState(() {
                          _isScanned = false; // Permitimos escanear otra vez
                        });
                      },
                      onAdd: () {
                        // Aquí puedes agregar alguna acción extra antes de navegar
                      },
                    ),
                  );

                  break; // Salimos del ciclo porque ya procesamos un código
                }
              }
            },
          ),

          // Capa superior con animación de línea que se mueve en el área de escaneo
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (_, __) => CustomPaint(
                painter: ScannerOverlayPainter(
                  scanRect: scanRect,
                  linePosition: _animationController.value,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Pintor personalizado para dibujar el área de escaneo y la línea animada
class ScannerOverlayPainter extends CustomPainter {
  final Rect scanRect;
  final double linePosition;

  ScannerOverlayPainter({
    required this.scanRect,
    required this.linePosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Pintura para el fondo oscuro semi-transparente
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.5);

    // Paths para crear un recuadro con "hueco" donde va el área de escaneo
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final holePath = Path()..addRect(scanRect);
    final overlay = Path.combine(PathOperation.difference, backgroundPath, holePath);

    // Pintamos la superposición oscura fuera del área de escaneo
    canvas.drawPath(overlay, overlayPaint);

    // Pintura para el borde blanco del área de escaneo
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawRect(scanRect, borderPaint);

    // Calculamos la posición vertical de la línea animada dentro del área de escaneo
    final lineY = scanRect.top + (scanRect.height * linePosition);

    // Pintura para la línea roja animada
    final linePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    // Dibujamos la línea horizontal en la posición calculada
    canvas.drawLine(
      Offset(scanRect.left, lineY),
      Offset(scanRect.right, lineY),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) =>
      oldDelegate.linePosition != linePosition || oldDelegate.scanRect != scanRect;
}
