import 'package:flutter/material.dart';

class MessageValidateOCR extends StatefulWidget {
  final String extractedText;
  final bool vieneDeValidar;

  const MessageValidateOCR({
    super.key,
    required this.extractedText,
    required this.vieneDeValidar,
  });

  @override
  State<MessageValidateOCR> createState() => _MessageValidateOCRState();
}

class _MessageValidateOCRState extends State<MessageValidateOCR> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.extractedText);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Texto detectado', style: TextStyle(color: Colors.blue[800])),
      content: _isEditing
          ? TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            )
          : Text(_controller.text),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _controller.text =
                  _controller.text.trim().toUpperCase();
              _isEditing = !_isEditing;
            });
          },
          child: Text(
            _isEditing ? 'Guardar' : 'Editar',
            style: TextStyle(color: Colors.blue[800]),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              _controller.text.trim().toUpperCase(),
            );
          },
          child: Text(
            widget.vieneDeValidar ? 'Validar' : 'Agregar',
            style: TextStyle(color: Colors.blue[800]),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Intentar de nuevo',
            style: TextStyle(color: Colors.blue[800]),
          ),
        ),
      ],
    );
  }
}
