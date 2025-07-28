import 'package:flutter/material.dart';

class MessageValidateBarcode extends StatelessWidget {
  final String barcodeText;

  const MessageValidateBarcode({
    Key? key,
    required this.barcodeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(20),
        color: Colors.green[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  'Código válido: $barcodeText',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
