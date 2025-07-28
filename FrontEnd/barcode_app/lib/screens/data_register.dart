import 'package:flutter/material.dart';
import '../widgets/message_registro_exitoso.dart'; // Importación del mensaje exitoso

class DataRegister extends StatelessWidget {
  final String extractedText; // Recibimos el texto escaneado

  const DataRegister({super.key, required this.extractedText});

  @override
  Widget build(BuildContext context) {
    final scrollController1 = ScrollController();
    final scrollController2 = ScrollController();

    // Simulamos que extraes otro texto para el código de barras (puedes reemplazarlo)
    final String codigoBarras = '1234567890123'; // Aquí puedes pasarlo como parámetro si gustas

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

                // Primer cuadro de texto (OCR)
                SizedBox(
                  height: 150,
                  child: TextField(
                    controller: TextEditingController(text: extractedText),
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

                // Segundo cuadro de texto (Código de barras, solo lectura)
                SizedBox(
                  height: 150,
                  child: TextField(
                    controller: TextEditingController(text: codigoBarras),
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
