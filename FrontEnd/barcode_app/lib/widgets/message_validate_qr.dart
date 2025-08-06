import 'package:flutter/material.dart';
import 'package:Scannet_Tecomnet/screens/scan_sim.dart';

class MessageValidateQR extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback onTryAgain;
  final VoidCallback? onAdd;

  const MessageValidateQR({
    required this.title,
    required this.content,
    required this.onTryAgain,
    this.onAdd,
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
    return AlertDialog(
      title: Text(widget.title,
      style: TextStyle(color: Colors.blue[800])),
      content: _isEditing
          ? TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            )
          : Text(_controller.text),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _isEditing = !_isEditing;
            });
          },
          child: Text(_isEditing ? 'Guardar' : 'Editar',
          style: TextStyle(color: Colors.blue[800]),),
        ),
        if (widget.onAdd != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ScanSim(vinText: _controller.text), // Pasa texto editado
                ),
              );
            },
            child: Text("Agregar",
          style: TextStyle(color: Colors.blue[800]),),
        ),
        TextButton(
          onPressed: () {
            widget.onTryAgain();
            Navigator.pop(context);
          },
          child: Text("Intentar de nuevo",
          style: TextStyle(color: Colors.blue[800]),
        ),
        ),
      ],
    );
  }
}