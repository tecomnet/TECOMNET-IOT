import 'package:flutter/material.dart';

class MessageInvalidateOCR extends StatelessWidget {
  const MessageInvalidateOCR({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Texto',
        style: TextStyle(color: Colors.blue[800]),
      ),
      content: const Text('Texto no escaneado'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
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
