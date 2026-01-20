import 'package:flutter/material.dart';
import '../widgets/menu_lateral.dart';
import 'scan_ocr.dart';
import 'scan_qr.dart';

class ScanVin extends StatefulWidget {
  final bool vieneDeValidar;
  const ScanVin({super.key, this.vieneDeValidar = false});

  @override
  State<ScanVin> createState() => _ScanVinState();
}

class _ScanVinState extends State<ScanVin> {
  String _selectedOption = 'QR';

  void _navigateToScan() {
    if (_selectedOption == 'OCR') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanOcr(vieneDeValidar: widget.vieneDeValidar),
        ),
      );
    } else if (_selectedOption == 'QR') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanQR(vieneDeValidar: widget.vieneDeValidar),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('ScanVin vieneDeValidar: ${widget.vieneDeValidar}');
  }

  @override
  Widget build(BuildContext context) {
    final bool desdeValidar = widget.vieneDeValidar;
    return Scaffold(
      appBar: AppBar(
        title: Text(desdeValidar ? 'Busqueda por VIN' : 'Escaneo VIN'),

        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
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
              const SizedBox(height: 30),
              RadioListTile<String>(
                title: const Text('QR', style: TextStyle(fontSize: 20)),
                value: 'QR',
                groupValue: _selectedOption,
                activeColor: Colors.blue[800],
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('OCR', style: TextStyle(fontSize: 20)),
                value: 'OCR',
                groupValue: _selectedOption,
                activeColor: Colors.blue[800],
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _navigateToScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 10,
                  ),
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
