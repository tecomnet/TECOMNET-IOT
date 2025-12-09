import 'package:flutter/material.dart';
import '../screens/data_register.dart';

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
      title: Text(
        'Texto',
        style: TextStyle(color: Colors.blue[800]),
      ),
      content: _isEditing
          ? TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onChanged: (value) {},
            )
          : Text(
              _controller.text
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
          onPressed: widget.onAdd ??
              () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DataRegister(
                      vinText: "", // Dejar VIN vacío
                      simText: _controller.text, // Usar como SIM
                      extractedText: _controller.text,
                    ),
                  ),
                );
              },
          child: Text(
            'Agregar',
            style: TextStyle(color: Colors.blue[800]),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onTryAgain();
            Navigator.pop(context);
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
