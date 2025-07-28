import 'package:flutter/material.dart';
import 'package:barcode_app/screens/scan_barcode.dart';
import 'package:barcode_app/screens/scan_ocr.dart';
import '../widgets/menu_lateral.dart';
import '../main.dart'; // Para regresar a la pantalla inicial

class ScanSim extends StatefulWidget {
  const ScanSim({super.key});

  @override
  State<ScanSim> createState() => _ScanSimState();
}

class _ScanSimState extends State<ScanSim> {
  String? _selectedOption = 'Barcode'; // 'Barcode' o 'OCR'

  void _navigateToScan() {
    if (_selectedOption == 'Barcode') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScanBarcode()),
      );
    } else if (_selectedOption == 'OCR') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScanOcr()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneo SIM'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const StartPage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      endDrawer: const MenuLateral(),
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
                title: const Text('Barcode'),
                value: 'Barcode',
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('OCR'),
                value: 'OCR',
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
