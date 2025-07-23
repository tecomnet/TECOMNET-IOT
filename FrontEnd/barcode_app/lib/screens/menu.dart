import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Text(
              'Menú',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Opción 1'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              // Acción al seleccionar la opción
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Opción 2'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              // Acción al seleccionar la opción
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Opción 3'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              // Acción al seleccionar la opción
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar sesión'),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer
              // Acción de cierre de sesión
            },
          ),
        ],
      ),
    );
  }
}
