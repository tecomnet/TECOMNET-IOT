import 'package:flutter/material.dart';

class MessageExitoso extends StatelessWidget {
  const MessageExitoso({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(""),
      content: const Text(
        "✅ Registro exitoso",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el diálogo
            Navigator.pushReplacementNamed(context, '/login'); // Navega a login
          },
          child: const Text('Cerrar'),
        ),
        // Opcional: botón para navegar a otra pantalla si quieres
         TextButton(
           onPressed: () {
             Navigator.of(context).pop();
             Navigator.pushReplacementNamed(context, '/scanVin');
           },
           child: const Text('Nuevo registro'),
         ),
      ],
    );
  }
}
