import 'package:flutter/material.dart';

class DataRegister extends StatelessWidget {
  final String extractedText;

  // Constructor que recibe el texto extraído
  DataRegister({required this.extractedText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Texto Escaneado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            extractedText.isNotEmpty
                ? extractedText
                : 'No se pudo extraer texto',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
