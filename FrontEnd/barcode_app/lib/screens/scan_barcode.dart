import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart'; // Paquete para escaneo de código de barras
import '../widgets/menu_lateral.dart'; // Menú lateral personalizado

class ScanBarcode extends StatefulWidget {
  const ScanBarcode({super.key});

  @override
  _ScanBarcodeState createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  String? _lastScannedCode; // Guarda el último código escaneado

  // Función para escanear código de barras
  Future<void> _scanBarcode() async {
    try {
      // Inicia la pantalla de escaneo
      String? scannedCode = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SimpleBarcodeScanner(
            onBarcodeViewCreated: (controller) {
              // Aquí puedes usar el controller si deseas controlar manualmente el escáner
            },
          ),
        ),
      );

      // Verifica si se obtuvo un código válido
      if (scannedCode != null && scannedCode.isNotEmpty) {
        setState(() {
          _lastScannedCode = scannedCode;
        });

        // Muestra el código escaneado en un diálogo
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Código Escaneado'),
              content: Text(scannedCode),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Cerrar diálogo
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      } else {
        // Si no se escaneó ningún código
        _showScanCancelledDialog();
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  // Diálogo cuando no se escanea ningún código
  void _showScanCancelledDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Escaneo Cancelado'),
          content: const Text('No se escaneó ningún código.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Diálogo de error
  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Ocurrió un error durante el escaneo: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneo con código de barras'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // Abre el menú lateral
              },
            ),
          ),
        ],
      ),
      endDrawer: const MenuLateral(), // Menú lateral personalizado
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.qr_code_scanner, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _scanBarcode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Escanear Código de Barras', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 24),
              if (_lastScannedCode != null)
                Column(
                  children: [
                    const Text(
                      'Último código escaneado:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _lastScannedCode!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
