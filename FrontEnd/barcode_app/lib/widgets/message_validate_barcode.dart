import 'package:flutter/material.dart';
import '../screens/data_register.dart';
import 'dialogo_escaneo.dart';

class MessageValidateBarcode extends StatefulWidget {
  final String barcodeText;
  final VoidCallback onTryAgain;
  final VoidCallback? onAdd;

  const MessageValidateBarcode({
    super.key,
    required this.barcodeText,
    required this.onTryAgain,
    this.onAdd,
  });

  @override
  State<MessageValidateBarcode> createState() => _MessageValidateBarcodeState();
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
    return DialogoEscaneo(
      icono: Icons.barcode_reader,
      titulo: 'Código detectado',
      contenido: TextoEscaneado(controller: _controller, editando: _isEditing),
      acciones: [
        DialogoEscaneo.primario(
          'Agregar',
          widget.onAdd ??
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
