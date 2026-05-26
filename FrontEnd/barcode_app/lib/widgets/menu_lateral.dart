import 'package:flutter/material.dart';
import 'package:scannet_tecomnet/screens/registros_incompletos.dart';
import 'package:scannet_tecomnet/screens/scan_vin.dart';
import 'package:scannet_tecomnet/services/api_services.dart';


class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    final int userType = AuthService.userType ?? -1;

    final bool puedeVerTodo = userType == 2;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue[800]),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Menú',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Opciones de navegación',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.qr_code_scanner_outlined,
              color: Colors.blue[800],
            ),
            title: const Text('Instalar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanVin(vieneDeValidar: false)),
              );
            },
          ),
          if (puedeVerTodo)
          ListTile(
            leading: Icon(Icons.check, color: Colors.green[800]),
            title: const Text('Validar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanVin(vieneDeValidar: true)),
              );
            },
          ),
          if (puedeVerTodo)
          ListTile(
            leading: Icon(Icons.close, color: Colors.red[800]),
            title: const Text('Registros incompletos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrosIncompletos()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.grey[800]),
            title: const Text('Cerrar sesión'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Cerrar sesión'),
                    content: const Text('¿Desea salir de la aplicación?'),
                    actions: [
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
                        },
                      ),
                      TextButton(
                        child: const Text('Sí'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
