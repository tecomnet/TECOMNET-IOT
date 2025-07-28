import 'package:flutter/material.dart';
import 'package:barcode_app/screens/scan_sim.dart'; // Importa ScanSim

class MessageValidateQR extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onTryAgain;
  final VoidCallback? onAdd; // nuevo flag para controlar navegación

  const MessageValidateQR({
    required this.title,
    required this.content,
    required this.onTryAgain,
    this.onAdd, // false por defecto
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            onTryAgain();
            Navigator.pop(context);
          },
          child: const Text("Intentar de nuevo"),
        ),
        if (onAdd != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo primero
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScanSim()),
              );
            },
            child: const Text("Agregar"),
          ),
      ],
    );
  }
}
