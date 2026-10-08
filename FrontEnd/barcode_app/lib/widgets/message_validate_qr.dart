import 'package:flutter/material.dart';
import 'dialogo_escaneo.dart';

class MessageValidateQR extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback onTryAgain;
  final bool vieneDeValidar;
  final VoidCallback? onAgregarPressed;

  const MessageValidateQR({
    required this.title,
    required this.content,
    required this.onTryAgain,
    required this.vieneDeValidar,
    this.onAgregarPressed,
    super.key,
  });

  @override
  State<MessageValidateQR> createState() => _MessageValidateQRState();
}

class _MessageValidateQRState extends State<MessageValidateQR> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DialogoEscaneo(
      icono: Icons.qr_code_2,
      titulo: widget.title,
      contenido: TextoEscaneado(controller: _controller, editando: _isEditing),
      acciones: [
        DialogoEscaneo.primario(
          widget.vieneDeValidar ? 'Validar' : 'Agregar',
          widget.onAgregarPressed,
        ),
        DialogoEscaneo.secundario(_isEditing ? 'Guardar' : 'Editar', () {
          setState(() {
            _isEditing = !_isEditing;
          });
        }),
        DialogoEscaneo.texto('Intentar de nuevo', () {
          widget.onTryAgain();
          Navigator.pop(context);
        }),
      ],
    );
  }
}
