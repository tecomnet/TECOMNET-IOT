import 'package:flutter/material.dart';

class MessageValidateOCR extends StatefulWidget {
  final String extractedText;
  final VoidCallback onAgregarPressed;

  const MessageValidateOCR({
    super.key,
    required this.extractedText,
    required this.onAgregarPressed,
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
      title: Text(
        'Texto',
        style: TextStyle(color: Colors.blue[800]),
      ),
      content: _isEditing
          ? TextField(
              controller: _textEditingController,
              onChanged: (newText) {
                setState(() {
                  _textEditingController.text = newText;
                });
              },
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            )
          : Text(
              widget.extractedText.isNotEmpty
                  ? widget.extractedText
                  : 'No se pudo extraer texto'
            ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _isEditing = !_isEditing;
            });
          },
          child: Text(
            _isEditing ? 'Guardar' : 'Editar',
            style: TextStyle(color: Colors.blue[800]),
          ),
        ),
        TextButton(
          onPressed: widget.onAgregarPressed,
          child: Text(
            'Agregar',
            style: TextStyle(color: Colors.blue[800]),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Intentar de nuevo',
            style: TextStyle(color: Colors.blue[800]),
          ),
        ),
      ],
    );
  }
}
