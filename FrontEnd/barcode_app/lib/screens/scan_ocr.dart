import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:scannet_tecomnet/services/api_services.dart';
import '../widgets/message_validate_ocr.dart';
import '../widgets/message_invalidate_ocr.dart';
import 'scan_sim.dart';
import 'data_register.dart';
import 'mostrar_datos_vehiculo.dart';

class ScanOcr extends StatefulWidget {
  final String? vinText;
  final bool vieneDeValidar;

  const ScanOcr({super.key, this.vinText, this.vieneDeValidar = false});

  @override
  _ScanOcrState createState() => _ScanOcrState();
}

class _ScanOcrState extends State<ScanOcr> with WidgetsBindingObserver {
  late final CameraController _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  bool _isFlashOn = false;
  XFile? _imageFile;
  String? origen;
  bool _shouldStopCamera = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (origen != null) return;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      origen = args['origen'] as String?;
    }
  }

  Future<void> _restartCamera() async {
    if (!_cameraController.value.isInitialized) return;

    setState(() {
      _shouldStopCamera = false;
      _isProcessing = false;
    });

    await _cameraController.resumePreview();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('No hay cámaras disponibles');
    }

    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );

    await _cameraController.initialize();
    await _cameraController.setFlashMode(FlashMode.off);

    setState(() {
      _isCameraInitialized = true;
      _shouldStopCamera = false;
    });
  }

  Future<void> _toggleFlash() async {
    if (!_isCameraInitialized || _shouldStopCamera) return;

    setState(() {
      _isFlashOn = !_isFlashOn;
    });

    await _cameraController.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized || _shouldStopCamera || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      XFile picture = await _cameraController.takePicture();

      setState(() {
        _imageFile = picture;
        _shouldStopCamera = true;
      });

      await _scanTextFromImage();
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error', style: TextStyle(color: Colors.red)),
          content: Text('Error: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _scanTextFromImage() async {
    File? croppedFile;

    if (_imageFile == null) return;

    try {
      final bytes = await File(_imageFile!.path).readAsBytes();
      final originalImage = img.decodeImage(bytes);
      if (originalImage == null) return;

      final imageWidth = originalImage.width;
      final imageHeight = originalImage.height;
      final screenSize = MediaQuery.of(context).size;
      final scanRect = Rect.fromCenter(
        center: Offset(screenSize.width / 2, screenSize.height / 2 - 60),
        width: screenSize.width * 0.8,
        height: screenSize.height * 0.125,
      );

      double scaleX = imageWidth / screenSize.width;
      double scaleY = imageHeight / screenSize.height;

      final cropX = (scanRect.left * scaleX).toInt();
      final cropY = (scanRect.top * scaleY).toInt();
      final cropWidth = (scanRect.width * scaleX).toInt();
      final cropHeight = (scanRect.height * scaleY).toInt();

      final croppedImage = img.copyCrop(
        originalImage,
        x: cropX,
        y: cropY,
        width: cropWidth,
        height: cropHeight,
      );

      croppedFile = File('${_imageFile!.path}_cropped.png');
      await croppedFile.writeAsBytes(img.encodePng(croppedImage));

      final inputImage = InputImage.fromFile(croppedFile);
      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );

      final recognizedText = await textRecognizer.processImage(inputImage);
      final extractedText = recognizedText.text;
      await textRecognizer.close();

      String cleanedText = _cleanExtractedText(
        extractedText,
      ); // ✅ Usamos la variable correcta

      bool isValidLength = true;
      String? errorMessage;

      if (origen == 'sim') {
        if (cleanedText.length != 20) {
          isValidLength = false;
          errorMessage = 'La SIM debe tener 20 caracteres';
        }
      } else {
        // VIN
        if (cleanedText.length != 17) {
          isValidLength = false;
          errorMessage = 'El VIN debe tener 17 caracteres';
        }
      }
      if (cleanedText.isEmpty || !isValidLength) {
        if (cleanedText.isEmpty) {
          showDialog(
            context: context,
            builder: (context) => const MessageInvalidateOCR(),
          ).then((_) => _restartCamera());
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Longitud incorrecta',
                style: TextStyle(color: Colors.blue[800]),
              ),
              content: Text(
                errorMessage ?? 'La longitud del texto no coincide',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _restartCamera();
                  },
                  child: Text(
                    'Reintentar',
                    style: TextStyle(color: Colors.blue[800]),
                  ),
                ),
              ],
            ),
          );
          if (await croppedFile.exists()) {
            await croppedFile.delete();
          }
        }
      } else {
        setState(() {
          _isProcessing = false;
        });

        final vinFinal = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (_) => MessageValidateOCR(
            extractedText: cleanedText,
            vieneDeValidar: widget.vieneDeValidar,
          ),
        );
        if (vinFinal == null) {
          await _restartCamera();
          return;
        }
        setState(() {
          _shouldStopCamera = true;
          _isProcessing = true;
        });

        await _cameraController.pausePreview();

        final vehiculoData = await AuthService.obtenerEstadoInstalacion(
          vinFinal,
        );

        // 🔹 FLUJO VALIDAR
        if (widget.vieneDeValidar) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MostrarDatosVehiculo(vehiculoData: vehiculoData),
            ),
          );
          return;
        }

        // 🔹 FLUJO SIM
        if (origen == 'sim') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DataRegister(
                vinText: widget.vinText ?? '',
                simText: vinFinal,
              ),
            ),
          );
          return;
        }

        // 🔹 FLUJO NORMAL
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ScanSim(vinText: vinFinal)),
        );
      }
    } finally {
      if (croppedFile != null && await croppedFile.exists()) {
        await croppedFile.delete();
      }
    }
  }

  String _cleanExtractedText(String text) {
    return text.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase().trim();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
      body: _isCameraInitialized && !_shouldStopCamera
          ? Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(_cameraController),
                ),
                Positioned.fill(
                  child: CustomPaint(painter: ScanAreaOverlayPainter()),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: GestureDetector(
                    onTap: _toggleFlash,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        _isFlashOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _isProcessing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Escanear',
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                  ),
                ),
              ],
            )
          : _shouldStopCamera
          ? Container(
              color: Colors.black,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Procesando imagen...',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(color: Colors.white),
                  ],
                ),
              ),
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
      center: Offset(size.width / 2, size.height / 2 - 60),
      width: size.width * 0.8,
      height: size.height * 0.125,
    );

    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final holePath = Path()..addRect(scanRect);
    final overlayPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      holePath,
    );

    canvas.drawPath(overlayPath, paint);
    canvas.drawRect(scanRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
