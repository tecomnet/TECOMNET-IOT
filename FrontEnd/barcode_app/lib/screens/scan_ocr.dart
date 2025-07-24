import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Para usar la cámara
import 'dart:io'; // Importa la clase 'File' para manejar imágenes
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // Importa el paquete para OCR
import '../widgets/menu_lateral.dart'; // Menú lateral (si lo tienes)
import 'data_register.dart'; // Asegúrate de importar la pantalla DataRegister

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
    final textRecognizer = TextRecognizer();
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

    // Muestra el texto extraído en un cuadro de diálogo
    _showExtractedTextDialog(cleanedText);
  }

  // Limpieza básica del texto extraído
  String _cleanExtractedText(String text) {
    text = text.replaceAll(RegExp(r'\s{2,}'), ' '); // Reemplaza múltiples espacios por uno solo
    text = text.replaceAll(RegExp(r'\n'), ' '); // Elimina saltos de línea innecesarios
    text = text.trim(); // Elimina espacios al principio y al final del texto

    return text;
  }

  // Mostrar el texto extraído en un cuadro de diálogo
  void _showExtractedTextDialog(String cleanedText) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Texto Extraído'),
          content: Text(cleanedText.isNotEmpty
              ? cleanedText
              : 'No se pudo extraer texto'),
          actions: [
            // Botón "Agregar" que navega a la pantalla DataRegister con el texto extraído
            // Botón para cerrar el cuadro de diálogo
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cerrar el cuadro de diálogo
              },
              child: const Text('Intentar de nuevo'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cerrar el cuadro de diálogo

                // Asegúrate de que el código de navegación está funcionando
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataRegister(extractedText: cleanedText),
                  ),
                );
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
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
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // Abre el menu lateral (endDrawer)
              },
            ),
          ),
        ],
      ),
      endDrawer: const MenuLateral(), // Menú lateral en el lado derecho
      body: _isCameraInitialized
          ? SingleChildScrollView(  // Envuelve el cuerpo en un SingleChildScrollView
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Contenedor para la vista previa de la cámara
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,  // Ajusta el ancho de la cámara
                        height: MediaQuery.of(context).size.height * 0.6,  // Aumenta la altura de la cámara al 60% de la pantalla
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CameraPreview(_cameraController), // Muestra la vista previa de la cámara
                      ),
                    ),
                    // Botón para tomar una foto con estilo
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _takePicture,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent, // Color de fondo
                          foregroundColor: Colors.white, // Color del texto
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Bordes redondeados
                          ),
                        ),
                        child: _isProcessing
                            ? const CircularProgressIndicator() // Indicador de carga si está procesando
                            : const Text(
                                'Tomar Foto',
                                style: TextStyle(fontSize: 25), // Tamaño de texto más grande
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()), // Cargando si la cámara no está lista
    );
  }
}
