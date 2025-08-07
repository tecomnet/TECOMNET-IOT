import 'package:scannet_tecomnet/screens/scan_sim.dart';

import './screens/data_register.dart';
import 'package:flutter/material.dart';
import 'widgets/menu_lateral.dart';
import 'screens/scan_vin.dart';
import './screens/login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: const Login(), // Ahora inicia directamente con el Login
      routes: {
        '/login': (context) => const Login(),
        '/start': (context) => const StartPage(), // Nueva ruta para la página inicial
        '/scanVin': (context) => const ScanVin(), 
        '/scanSim': (context) => const ScanSim(), 
        // Ruta modificada para recibir argumentos
        '/data_register': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return DataRegister(
            vinText: args?['vinText'] ?? '',  // Valor por defecto si no se proporciona
            simText: args?['simText'] ?? '',  // Valor por defecto si no se proporciona
          );
        },
      },
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
      ),
      endDrawer: const MenuLateral(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/scanVin');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
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
    );
  }
}