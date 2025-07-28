import 'package:flutter/material.dart';

class MessageInvalidateOCR extends StatelessWidget {
  const MessageInvalidateOCR({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Texto'),
      content: const Text('Texto no escaneado'),
      actions: [
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
