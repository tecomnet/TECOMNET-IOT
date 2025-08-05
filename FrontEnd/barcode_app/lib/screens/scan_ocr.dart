import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import '../widgets/message_validate_ocr.dart';
import '../widgets/message_invalidate_ocr.dart';
import 'scan_sim.dart';
import 'data_register.dart';

class ScanOcr extends StatefulWidget {
  final String? vinText; // Texto del VIN escaneado previamente

  const ScanOcr({super.key, this.vinText});

  @override
  _ScanOcrState createState() => _ScanOcrState();
}

class _ScanOcrState extends State<ScanOcr> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  XFile? _imageFile;
  String _extractedText = "";
  String? origen;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    setState(() {
      origen = routeArgs?['origen'] as String?;
    });
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();

    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      XFile picture = await _cameraController.takePicture();
      setState(() {
        _imageFile = picture;
        _isProcessing = false;
      });

      await _scanTextFromImage();
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Ocurrió un error durante la captura de la imagen: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _scanTextFromImage() async {
    if (_imageFile == null) return;

    final bytes = await File(_imageFile!.path).readAsBytes();
    final originalImage = img.decodeImage(bytes);
    if (originalImage == null) return;

    final imageWidth = originalImage.width;
    final imageHeight = originalImage.height;

    final cropWidth = (imageWidth * 0.9).toInt();
    final cropHeight = (imageHeight * 0.125).toInt();
    final cropX = ((imageWidth - cropWidth) / 2 ).toInt();
    final cropY = ((imageHeight - cropHeight) / 2).toInt();

    final croppedImage = img.copyCrop(
      originalImage,
      x: cropX,
      y: cropY,
      width: cropWidth,
      height: cropHeight,
    );

    final croppedFile = await File('${_imageFile!.path}_cropped.png').writeAsBytes(
      img.encodePng(croppedImage),
    );

    final inputImage = InputImage.fromFile(croppedFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        _extractedText = recognizedText.text;
      });
    } catch (e) {
      print("Error al procesar imagen recortada: $e");
    } finally {
      textRecognizer.close();
    }

    String cleanedText = _cleanExtractedText(_extractedText);

    if (cleanedText.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const MessageInvalidateOCR(),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => MessageValidateOCR(
          extractedText: cleanedText,
          onAgregarPressed: () {
            // Cerrar el diálogo primero
            Navigator.of(context).pop();
            
            // Lógica de navegación basada en el origen
            if (origen == 'scanvin') {
              // Para primer OCR: navegar a ScanSim pasando el texto VIN
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanSim(vinText: cleanedText),
                ),
              );
            } else if (origen == 'sim') {
              // Para segundo OCR: navegar a DataRegister con ambos textos
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DataRegister(
                    vinText: widget.vinText ?? '', // Texto del primer OCR
                    simText: cleanedText,         // Texto del segundo OCR
                  ),
                ),
              );
            } else {
              // Comportamiento por defecto (volver atrás)
              Navigator.pop(context);
            }
          },
        ),
      );
    }
  }

  String _cleanExtractedText(String text) {
    text = text.replaceAll(RegExp(r'\s{2,}'), ' ');
    text = text.replaceAll(RegExp(r'\n'), ' ');
    return text.trim();
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
        title: const Text('Escaneo con OCR'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: _isCameraInitialized
          ? Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(_cameraController),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: ScanAreaOverlayPainter(),
                  ),
                ),
                Positioned(
                  bottom: 180,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _takePicture,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isProcessing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Escanear', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class ScanAreaOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.5);

    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final scanRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2 -60),
      width: size.width * 0.8,
      height: size.height * 0.125,
    );

    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final holePath = Path()..addRect(scanRect);
    final overlayPath = Path.combine(PathOperation.difference, backgroundPath, holePath);

    canvas.drawPath(overlayPath, paint);
    canvas.drawRect(scanRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}