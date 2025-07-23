import 'package:flutter/material.dart';
import '../widgets/menuLateral.dart'; // Asegúrate de que esta importación sea correcta

class ScanBarcode extends StatelessWidget {
  const ScanBarcode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneo Código de Barras'),
        actions: [
          // Aquí usamos un Builder para asegurarnos de que el contexto es correcto
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // Abre el menu lateral (endDrawer)
              },
            ),
          ),
        ],
      ),
      endDrawer: const MenuLateral(), // Menú lateral en el lado derecho
      body: const Center(child: Text('Aquí va la funcionalidad de Código de Barras')),
    );
  }
}
