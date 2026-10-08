import 'package:flutter/material.dart';
import 'dialogo_escaneo.dart';

/// Diálogo para informar que el registro del vehículo falló.
class MessageRegistroFallido extends StatelessWidget {
  final String mensaje;
  final VoidCallback? onReintentar;

  const MessageRegistroFallido({
    super.key,
    this.mensaje = 'No se pudo completar el registro. Inténtalo de nuevo.',
    this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return DialogoEscaneo(
      icono: Icons.error_outline,
      colorIcono: Colors.red[700]!,
      titulo: 'Registro fallido',
      contenido: Text(
        mensaje,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
      ),
      acciones: [
        if (onReintentar != null)
          DialogoEscaneo.primario('Reintentar', () {
            Navigator.of(context).pop();
            onReintentar!();
          }),
        DialogoEscaneo.texto('Cerrar', () => Navigator.of(context).pop()),
      ],
    );
  }
}
