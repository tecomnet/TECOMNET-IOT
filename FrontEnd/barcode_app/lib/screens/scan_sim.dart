import 'package:flutter/material.dart';
import 'package:scannet_tecomnet/screens/scan_barcode.dart';
import 'package:scannet_tecomnet/screens/scan_ocr.dart';
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
            Navigator.pop(context);
          },
        ),
      ),
      endDrawer: const MenuLateral(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            children: [
              const Text(
                'Selecciona tipo de escaneo:',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              RadioListTile<String>(
                title: const Text('Barcode', style: TextStyle(fontSize: 20)),
                value: 'Barcode',
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('OCR', style: TextStyle(fontSize: 20)),
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
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Siguiente', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}