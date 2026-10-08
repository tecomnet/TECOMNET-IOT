import 'package:flutter/material.dart';
import 'dialogo_escaneo.dart';

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DialogoEscaneo(
      icono: Icons.text_fields,
      titulo: 'Texto detectado',
      contenido: TextoEscaneado(controller: _controller, editando: _isEditing),
      acciones: [
        DialogoEscaneo.primario(
          widget.vieneDeValidar ? 'Validar' : 'Agregar',
          () {
            Navigator.pop(context, _controller.text.trim().toUpperCase());
          },
        ),
        DialogoEscaneo.secundario(_isEditing ? 'Guardar' : 'Editar', () {
          setState(() {
            _controller.text = _controller.text.trim().toUpperCase();
            _isEditing = !_isEditing;
          });
        }),
        DialogoEscaneo.texto('Intentar de nuevo', () => Navigator.pop(context)),
      ],
    );
  }
}
