import 'package:flutter/material.dart';
import 'dialogo_escaneo.dart';

class MessageInvalidateOCR extends StatelessWidget {
  const MessageInvalidateOCR({super.key});

  @override
  Widget build(BuildContext context) {
    return DialogoEscaneo(
      icono: Icons.text_fields,
      colorIcono: Colors.orange[800]!,
      titulo: 'Texto no escaneado',
      contenido: Text(
        'No se pudo leer ningún texto. Acerca la cámara, mejora la '
        'iluminación e inténtalo de nuevo.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
      ),
      acciones: [
        DialogoEscaneo.primario('Intentar de nuevo', () {
          Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
        }),
      ],
    );
  }
}
