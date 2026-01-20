import 'package:flutter/material.dart';
import 'package:scannet_tecomnet/screens/scan_vin.dart';
import 'package:scannet_tecomnet/widgets/menu_lateral.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Future<bool> _confirmarSalida(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Salir'),
        content: const Text('¿Desea salir de la aplicación?', style: TextStyle(fontSize: 18),),
        actions: [
          TextButton(
            child: const Text('No', style: TextStyle(fontSize: 18),),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Sí', style: TextStyle(fontSize: 18),),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );

    if (result == true) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }

    return false; // Evita el cierre automático
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
  onWillPop: () => _confirmarSalida(context), 
    child: Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
      ),
      endDrawer: const MenuLateral(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          children: [
            Center(
              child: Text(
                'Bienvenido al registro de vehículos',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold, // Texto en negrita
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScanVin(vieneDeValidar: false)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Comenzar',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    )));
  }
}