import 'package:flutter/material.dart';

/// Estructura común de los diálogos de resultado de escaneo:
/// ícono, título, contenido y botones apilados.
class DialogoEscaneo extends StatelessWidget {
  final IconData icono;
  final Color colorIcono;
  final String titulo;
  final Widget contenido;
  final List<Widget> acciones;

  const DialogoEscaneo({
    super.key,
    required this.icono,
    required this.titulo,
    required this.contenido,
    required this.acciones,
    this.colorIcono = const Color(0xFF1565C0), // azul 800
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorIcono.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icono, size: 36, color: colorIcono),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 16),
              contenido,
              const SizedBox(height: 24),
              ...acciones.expand((w) => [w, const SizedBox(height: 8)]),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Botones ----------

  static Widget primario(
    String texto,
    VoidCallback? onPressed, {
    Color? color,
  }) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.blue[800],
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static Widget secundario(String texto, VoidCallback? onPressed) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue[800],
          side: BorderSide(color: Colors.blue.shade300, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static Widget texto(String texto, VoidCallback? onPressed) {
    return SizedBox(
      height: 44,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
        child: Text(
          texto,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// Muestra el texto detectado en una caja, o un campo si se está editando.
class TextoEscaneado extends StatelessWidget {
  final TextEditingController controller;
  final bool editando;

  const TextoEscaneado({
    super.key,
    required this.controller,
    required this.editando,
  });

  @override
  Widget build(BuildContext context) {
    if (editando) {
      return TextField(
        controller: controller,
        maxLines: null,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: SelectableText(
        controller.text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: Colors.blue[900],
        ),
      ),
    );
  }
}
