import 'package:flutter/material.dart';
import 'dialogo_escaneo.dart';

/// Pregunta si se desea cerrar sesión. Devuelve true si el usuario confirma.
Future<bool> confirmarCerrarSesion(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => DialogoEscaneo(
      icono: Icons.logout,
      colorIcono: Colors.red[700]!,
      titulo: 'Cerrar sesión',
      contenido: Text(
        '¿Desea salir de la aplicación?',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 17, color: Colors.grey[800]),
      ),
      acciones: [
        DialogoEscaneo.primario(
          'Sí, salir',
          () => Navigator.of(context).pop(true),
          color: Colors.red[700],
        ),
        DialogoEscaneo.secundario('No', () => Navigator.of(context).pop(false)),
      ],
    ),
  );
  return result == true;
}
