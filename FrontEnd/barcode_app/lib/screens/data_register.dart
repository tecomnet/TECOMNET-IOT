import 'package:flutter/material.dart';
import '../widgets/message_registro_exitoso.dart';

class DataRegister extends StatelessWidget {
  final String vinText; // Texto del primer OCR (VIN)
  final String simText; // Texto del segundo OCR (SIM)
  final String? extractedText; // Nuevo parámetro para compatibilidad

  const DataRegister({
    super.key, 
    required this.vinText, 
    required this.simText,
    this.extractedText, // Parámetro adicional agregado
  });

  @override
  Widget build(BuildContext context) {
    final scrollController1 = ScrollController();
    final scrollController2 = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Datos'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Texto Capturado:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Primer cuadro de texto (OCR VIN)
                SizedBox(
                  height: 150,
                  child: TextField(
                    controller: TextEditingController(text: vinText),
                    readOnly: true,
                    maxLines: null,
                    expands: true,
                    scrollController: scrollController1,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Resultado VIN',
                      alignLabelWithHint: true,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Segundo cuadro de texto (OCR SIM)
                SizedBox(
                  height: 150,
                  child: TextField(
                    controller: TextEditingController(text: simText),
                    readOnly: true,
                    maxLines: null,
                    expands: true,
                    scrollController: scrollController2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Resultado SIM',
                      alignLabelWithHint: true,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Botón Registrar
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MessageExitoso(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Registrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}