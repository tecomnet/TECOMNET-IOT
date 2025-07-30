import 'package:flutter/material.dart';

class MessageValidateOCR extends StatefulWidget {
  final String extractedText;
  final VoidCallback onAgregarPressed; // Nuevo parámetro

  const MessageValidateOCR({
    super.key,
    required this.extractedText,
    required this.onAgregarPressed, // Añadido aquí
  });

  @override
  _MessageValidateOCRState createState() => _MessageValidateOCRState();
}

class _MessageValidateOCRState extends State<MessageValidateOCR> {
  late TextEditingController _textEditingController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.extractedText);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Texto'),
      content: _isEditing
          ? TextField(
              controller: _textEditingController,
              onChanged: (newText) {
                setState(() {
                  // Actualizamos el texto en el widget padre a través del controlador
                  _textEditingController.text = newText;
                });
              },
              maxLines: null,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            )
          : Text(
              widget.extractedText.isNotEmpty ? widget.extractedText : 'No se pudo extraer texto',
            ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _isEditing = !_isEditing;
              if (!_isEditing) {
                // Guardar cambios al salir del modo edición
                _textEditingController.text = _textEditingController.text;
              }
            });
          },
          child: Text(_isEditing ? 'Guardar' : 'Editar'),
        ),
        TextButton(
          onPressed: widget.onAgregarPressed, // Usamos el callback proporcionado
          child: const Text('Agregar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar diálogo
          },
          child: const Text('Intentar de nuevo'),
        ),
      ],
    );
  }
}