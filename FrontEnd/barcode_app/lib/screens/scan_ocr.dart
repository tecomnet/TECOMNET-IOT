import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Para usar la cámara
import 'dart:io'; // Importa la clase 'File' para manejar imágenes
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // Importa el paquete para OCR
import '../widgets/message_validate_ocr.dart'; // Importa el diálogo cuando se extrae texto correctamente
import '../widgets/message_invalidate_ocr.dart'; // Importa el diálogo cuando no se detecta texto

class ScanOcr extends StatefulWidget {
  const ScanOcr({super.key});

  @override
  _ScanOcrState createState() => _ScanOcrState();
}

class _ScanOcrState extends State<ScanOcr> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  XFile? _imageFile;
  String _extractedText = ""; // Variable para almacenar el texto extraído

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Inicializar la cámara
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();  // Obtén las cámaras disponibles
    _cameraController = CameraController(
      _cameras[0], // Usamos la primera cámara disponible (normalmente la cámara trasera)
      ResolutionPreset.medium, // Resolución media para una imagen más pequeña
    );
    await _cameraController.initialize(); // Inicializa el controlador de la cámara

    setState(() {
      _isCameraInitialized = true; // Indica que la cámara está lista
    });
  }

  // Tomar una foto
  Future<void> _takePicture() async {
    if (!_isCameraInitialized) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Tomar una foto
      XFile picture = await _cameraController.takePicture();
      setState(() {
        _imageFile = picture; // Guardar la imagen capturada
        _isProcessing = false;
      });

      // Procesar la imagen con OCR
      _scanTextFromImage();
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      // Mostrar un mensaje de error si algo salió mal
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Ocurrió un error durante la captura de la imagen: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();  // Cerrar el diálogo
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }

  // Función para detectar texto utilizando OCR
  Future<void> _scanTextFromImage() async {
    if (_imageFile == null) return;

    final inputImage = InputImage.fromFile(File(_imageFile!.path));
    // Aquí la modificación para usar solo script latino:
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        _extractedText = recognizedText.text; // Almacena el texto extraído
      });
    } catch (e) {
      print("Error al procesar la imagen: $e");
    } finally {
      textRecognizer.close(); // Liberamos los recursos
    }

    // Limpia y mejora el texto extraído
    String cleanedText = _cleanExtractedText(_extractedText);

    // Muestra el cuadro de diálogo adecuado
    if (cleanedText.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return const MessageInvalidateOCR(); // Muestra el mensaje cuando no se escanea texto
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return MessageValidateOCR(extractedText: cleanedText); // Muestra el texto extraído
        },
      );
    }
  }

  // Limpieza básica del texto extraído
  String _cleanExtractedText(String text) {
    text = text.replaceAll(RegExp(r'\s{2,}'), ' '); // Reemplaza múltiples espacios por uno solo
    text = text.replaceAll(RegExp(r'\n'), ' '); // Elimina saltos de línea innecesarios
    text = text.trim(); // Elimina espacios al principio y al final del texto

    return text;
  }

  @override
  void dispose() {
    _cameraController.dispose();  // Liberar el controlador de la cámara
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneo con OCR'),
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
                        child: CameraPreview(_cameraController), // Muestra la vista previa de la cámara
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _takePicture,
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
