// scan_barcode.dart
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ScanBarcode extends StatelessWidget {
  const ScanBarcode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleBarcodeScannerPage(
      appBarTitle: 'Escanear Código',
      cancelButtonText: 'Cancelar',
      lineColor: "#ff6666", // color de la línea del escáner
      scanType: ScanType.barcode, // puedes cambiar a ScanType.qr para QR
    );
  }
}
