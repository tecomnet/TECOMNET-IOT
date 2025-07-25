import 'package:flutter/material.dart';
import '../screens/data_register.dart'; // Asegúrate de importar la pantalla DataRegister

class MessageValidate extends StatefulWidget {
  String extractedText; // Cambié a `String` para que sea mutable dentro del widget

  MessageValidate({required this.extractedText, super.key});

  @override
  _MessageValidateState createState() => _MessageValidateState();
}

class _MessageValidateState extends State<MessageValidate> {
  late TextEditingController _textEditingController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Inicializamos el controlador con el texto extraído
    _textEditingController = TextEditingController(text: widget.extractedText);
  }

  @override
  void dispose() {
    _textEditingController.dispose(); // Limpiamos el controlador cuando se elimine el widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Texto Extraído'),
      content: _isEditing
          ? TextField(
              controller: _textEditingController,
              onChanged: (newText) {
                // Actualiza el texto mientras el usuario escribe
                setState(() {
                  widget.extractedText = newText; // Guarda el texto editado en la variable local
                });
              },
              maxLines: null, // Permite múltiples líneas
              decoration: const InputDecoration(border: OutlineInputBorder()),
            )
          : Text(
              widget.extractedText.isNotEmpty ? widget.extractedText : 'No se pudo extraer texto',
            ),
      actions: [
        // Botón para cambiar entre edición y visualización
        TextButton(
          onPressed: () {
            setState(() {
              _isEditing = !_isEditing; // Cambiar el estado de edición
            });
          },
          child: Text(_isEditing ? 'Guardar' : 'Editar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar el cuadro de diálogo

            // Si se está editando, guardamos el texto
            if (_isEditing) {
              widget.extractedText = _textEditingController.text; // Actualiza el texto editado
            }

            // Asegúrate de que el código de navegación está funcionando
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DataRegister(extractedText: widget.extractedText),
              ),
            );
          },
          child: const Text('Agregar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
          },
          child: const Text('Intentar de nuevo'),
        ),
      ],
    );
  }
}
