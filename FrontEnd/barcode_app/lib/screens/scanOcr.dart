import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Para usar la cámara
import 'dart:io'; // Importa la clase 'File' para manejar imágenes
import 'package:google_ml_kit/google_ml_kit.dart'; // Importa GoogleMlKit para el OCR
import '../widgets/menuLateral.dart'; // Asegúrate de que esta importación sea correcta

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
  late String _ocrText;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Inicializar la cámara con resolución baja para tamaño más pequeño
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

  // Capturar la imagen y procesarla con OCR
  Future<void> _captureAndScan() async {
    if (!_isCameraInitialized) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Tomar una foto
      XFile picture = await _cameraController.takePicture();
      File imageFile = File(picture.path);

      // Procesar la imagen con OCR
      final inputImage = InputImage.fromFile(imageFile);
      final textDetector = GoogleMlKit.vision.textDetector();
      final recognisedText = await textDetector.processImage(inputImage);

      setState(() {
        //_ocrText = recognisedText.text;  // Almacena el texto reconocido
        _isProcessing = false;
      });

      // Mostrar el texto reconocido en un diálogo
      _showOcrResultDialog(context);  // Aquí pasamos el contexto correctamente
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      // Mostrar un mensaje de error si algo salió mal
      showDialog(
        context: context, // Usamos el BuildContext aquí correctamente
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Ocurrió un error durante el procesamiento del OCR: $e'),
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

  // Mostrar los resultados del OCR en un diálogo
  void _showOcrResultDialog(BuildContext context) {
    showDialog(
      context: context, // Usamos el BuildContext aquí correctamente
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Texto Reconocido'),
          content: SingleChildScrollView(
            child: Text(_ocrText),  // Mostrar el texto reconocido
          ),
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

  @override
  void dispose() {
    _cameraController.dispose();  // Liberar el controlador de la cámara
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneo OCR'),
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
          ? Padding(
              padding: const EdgeInsets.all(16.0), // Agrega un margen alrededor de la vista de la cámara
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,  // Esto centra el contenido en el eje vertical
                children: [
                  // Contenedor para la vista previa de la cámara con un tamaño controlado y centrado
                  Center(  // Esto asegura que el contenedor esté centrado
                    child: Container(
                      width: 320,  // Ajusté el ancho para hacerlo más pequeño
                      height: 450,  // Ajusté la altura también
                      decoration: BoxDecoration(
                        color: Colors.black, // Fondo negro para la vista de la cámara
                        borderRadius: BorderRadius.circular(10), // Bordes redondeados
                      ),
                      child: CameraPreview(_cameraController), // Muestra la vista previa de la cámara
                    ),
                  ),
                  // Botón para capturar y procesar la imagen
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _captureAndScan,
                      child: _isProcessing
                          ? const CircularProgressIndicator()
                          : const Text('Capturar y Escanear'),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()), // Cargando si la cámara no está lista
    );
  }
}
