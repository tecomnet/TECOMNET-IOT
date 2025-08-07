import 'package:flutter/material.dart';
import 'package:scannet_tecomnet/screens/scan_barcode.dart';
import 'package:scannet_tecomnet/screens/scan_ocr.dart';
import 'package:scannet_tecomnet/screens/scan_vin.dart'; // Importa ScanVin
import '../widgets/menu_lateral.dart';

class ScanSim extends StatefulWidget {
  final String? vinText; // Texto del VIN escaneado previamente

  const ScanSim({super.key, this.vinText});

  @override
  State<ScanSim> createState() => _ScanSimState();
}

class _ScanSimState extends State<ScanSim> {
  String? _selectedOption = 'Barcode';

  void _navigateToScan() {
    if (_selectedOption == 'Barcode') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanBarcode(vinText: widget.vinText),
        ),
      );
    } else if (_selectedOption == 'OCR') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanOcr(vinText: widget.vinText),
          settings: const RouteSettings(arguments: {'origen': 'sim'}),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneo SIM'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Regresar a ScanVinScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ScanVin(),
              ),
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
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                  backgroundColor: Colors.blue[800],
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