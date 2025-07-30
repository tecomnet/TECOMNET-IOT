import 'package:flutter/material.dart';
import '../widgets/menu_lateral.dart';
import 'scan_ocr.dart';
import 'scan_qr.dart';
import '../main.dart';

class ScanVin extends StatefulWidget {
  const ScanVin({super.key});

  @override
  State<ScanVin> createState() => _ScanVinState();
}

class _ScanVinState extends State<ScanVin> {
  String? _selectedOption = 'QR';

  void _navigateToScan() {
    if (_selectedOption == 'OCR') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ScanOcr(),
          settings: const RouteSettings(arguments: {'origen': 'scanvin'}),
        ),
      );
    } else if (_selectedOption == 'QR') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScanQR()),
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
                title: const Text('QR'),
                value: 'QR',
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
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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