import 'package:flutter/material.dart';
import '../widgets/menuLateral.dart';
import 'scanOcr.dart';
import 'scanBarcode.dart';
import '../main.dart'; // Asegúrate de importar tu archivo principal

class ScanVin extends StatefulWidget {
  const ScanVin({super.key});

  @override
  State<ScanVin> createState() => _ScanVinState();
}

class _ScanVinState extends State<ScanVin> {
  String? _selectedOption = 'ocr'; // 'ocr' o 'codigo_barras'

  void _navigateToScan() {
    if (_selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una opción')),
      );
      return;
    }

    if (_selectedOption == 'ocr') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScanOcr()),
      );
    } else if (_selectedOption == 'codigo_barras') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScanBarcode()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneo VIN'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const StartPage()),
              (Route<dynamic> route) => false, // Elimina el historial
            );
          },
        ),
      ),
      endDrawer: const MenuLateral(), // Menú lateral en el lado derecho
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Selecciona tipo de escaneo:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              RadioListTile<String>(
                title: const Text('OCR'),
                value: 'ocr',
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Código de Barras'),
                value: 'codigo_barras',
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _navigateToScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Escanear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
