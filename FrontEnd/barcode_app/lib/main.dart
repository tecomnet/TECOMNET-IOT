import 'package:flutter/material.dart';
import 'package:scannet_tecomnet/screens/mostrar_datos_vehiculo.dart';
import 'package:scannet_tecomnet/screens/scan_sim.dart';
import './screens/data_register.dart';
import 'screens/scan_vin.dart';
import './screens/login.dart';
import './screens/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scannet Tecomnet',
      debugShowCheckedModeBanner: false,
      locale: const Locale('es', 'MX'),
      supportedLocales: const [
        Locale('es', 'MX'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const Login(),
      routes: {
        '/login': (context) => const Login(),
        '/start': (context) => const Home(), 
        '/scanVin': (context) => const ScanVin(), 
        '/scanSim': (context) => const ScanSim(), 
        '/mostrardatosvehiculo': (context) => const MostrarDatosVehiculo(),
        '/data_register': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return DataRegister(
            vinText: args?['vinText'] ?? '',
            simText: args?['simText'] ?? '',
          );
        },
      },
    );
  }
}
