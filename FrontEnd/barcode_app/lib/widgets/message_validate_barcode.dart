import 'package:flutter/material.dart';
import '../screens/data_register.dart'; // Asegúrate que la ruta es correcta

class MessageValidateBarcode extends StatefulWidget {
  final String barcodeText;
  final VoidCallback onTryAgain;
  final VoidCallback? onAdd;

  const MessageValidateBarcode({
    Key? key,
    required this.barcodeText,
    required this.onTryAgain,
    this.onAdd,
  }) : super(key: key);

  @override
  _MessageValidateBarcodeState createState() => _MessageValidateBarcodeState();
}

class _MessageValidateBarcodeState extends State<MessageValidateBarcode> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.barcodeText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Texto'),
      content: _isEditing
          ? TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onChanged: (value) {
                // Puedes actualizar el texto en tiempo real si quieres
              },
            )
          : Text(_controller.text),
      actions: [
        TextButton(
          onPressed: () {
            if (_isEditing) {
              // Guardar edición
              setState(() {
                _isEditing = false;
              });
            } else {
              // Cambiar a modo edición
              setState(() {
                _isEditing = true;
              });
            }
          },
          child: Text(_isEditing ? 'Guardar' : 'Editar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Cierra diálogo primero
            
            // Navegación actualizada con parámetros correctos
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DataRegister(
                  vinText: _controller.text, // Usar como VIN
                  simText: "",                // Dejar SIM vacío
                  extractedText: _controller.text, // Compatibilidad
                ),
              ),
            );
          },
          child: const Text('Agregar'),
        ),
        TextButton(
          onPressed: () {
            widget.onTryAgain();
            Navigator.pop(context);
          },
          child: const Text('Intentar de nuevo'),
        ),
      ],
    );
  }
}