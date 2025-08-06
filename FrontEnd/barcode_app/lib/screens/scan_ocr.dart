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
  final String? vinText;

  const ScanOcr({super.key, this.vinText});

  @override
  _ScanOcrState createState() => _ScanOcrState();
}

class _ScanOcrState extends State<ScanOcr> with WidgetsBindingObserver {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  bool _isFlashOn = false;
  XFile? _imageFile;
  String _extractedText = "";
  String? origen;
  bool _shouldStopCamera = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _stopCameraPreview();
    } else if (state == AppLifecycleState.resumed && !_shouldStopCamera) {
      _startCameraPreview();
    }
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
    await _cameraController.setFlashMode(FlashMode.off);
    
    setState(() {
      _isCameraInitialized = true;
      _shouldStopCamera = false;
    });
  }

  Future<void> _startCameraPreview() async {
    if (_cameraController.value.isInitialized && !_cameraController.value.isStreamingImages) {
      await _cameraController.startImageStream((image) {});
    }
  }

  Future<void> _stopCameraPreview() async {
    if (_cameraController.value.isStreamingImages) {
      await _cameraController.stopImageStream();
    }
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
    if (!_isCameraInitialized || _shouldStopCamera) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      await _stopCameraPreview();
      XFile picture = await _cameraController.takePicture();
      
      setState(() {
        _imageFile = picture;
        _isProcessing = false;
        _shouldStopCamera = true;
      });

      await _scanTextFromImage();
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      await _startCameraPreview();
      
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
            ]
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

    final croppedFile = File('${_imageFile!.path}_cropped.png');
    await croppedFile.writeAsBytes(img.encodePng(croppedImage));

    final inputImage = InputImage.fromFile(croppedFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        _extractedText = recognizedText.text;
      });
    } catch (e) {
      print("Error al procesar imagen: $e");
    } finally {
      textRecognizer.close();
    }

    String cleanedText = _cleanExtractedText(_extractedText);

    bool isValidLength = true;
    String? errorMessage;

    if (origen == 'scanvin' && cleanedText.length != 17) {
      isValidLength = false;
      errorMessage = 'El VIN debe tener 17 caracteres';
    } else if (origen == 'sim' && cleanedText.length != 20) {
      isValidLength = false;
      errorMessage = 'La SIM debe tener 20 caracteres';
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
            title: Text('Longitud incorrecta', style: TextStyle(color: Colors.blue[800])),
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
                child: Text('Reintentar', style: TextStyle(color: Colors.blue[800])),
              ),
            ]
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => MessageValidateOCR(
          extractedText: cleanedText,
          onAgregarPressed: () {
            Navigator.of(context).pop();
            
            if (origen == 'scanvin') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanSim(vinText: cleanedText),
                ),
              );
            } else if (origen == 'sim') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DataRegister(
                    vinText: widget.vinText ?? '',
                    simText: cleanedText,
                  ),
                ),
              );
            }
          },
        ),
      ).then((_) {
        if (mounted) {
          _restartCamera();
        }
      });
    }
  }

  Future<void> _restartCamera() async {
    setState(() {
      _shouldStopCamera = false;
    });
    
    if (_cameraController.value.isInitialized) {
      await _startCameraPreview();
    }
  }

  String _cleanExtractedText(String text) {
    text = text.replaceAll(RegExp(r'\s{2,}'), ' ');
    text = text.replaceAll(RegExp(r'\n'), ' ');
    return text.trim();
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
                  child: CustomPaint(
                    painter: ScanAreaOverlayPainter(),
                  ),
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

    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final holePath = Path()..addRect(scanRect);
    final overlayPath = Path.combine(PathOperation.difference, backgroundPath, holePath);

    canvas.drawPath(overlayPath, paint);
    canvas.drawRect(scanRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}