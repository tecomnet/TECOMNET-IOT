import 'package:flutter/material.dart';
import 'dart:io';
import 'package:barcode_app/services/api_services.dart'; // Asegúrate de que este archivo esté importado correctamente.

class Login extends StatelessWidget {
  const Login({super.key});

  // Validación del correo (expresión regular para validar formato de correo)
  bool esCorreoValido(String correo) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(correo);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController usuarioController = TextEditingController();
    final TextEditingController contrasenaController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F8), // Color de fondo suave opcional
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Inicio de sesión',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Campo usuario
                TextField(
                  controller: usuarioController,
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo contraseña
                TextField(
                  controller: contrasenaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 24),

                // Botón Iniciar sesión
                ElevatedButton(
                  onPressed: () async {
                    final usuario = usuarioController.text.trim();
                    final contrasena = contrasenaController.text.trim();

                    // Validación de los campos
                    if (usuario.isEmpty || contrasena.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, ingresa tus datos'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    // Validar el formato del correo
                    if (!esCorreoValido(usuario)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ingresa un correo válido'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Llamar al servicio de autenticación
                    bool tokenObtenido = await AuthService.obtenerToken(usuario, contrasena);

                    if (!tokenObtenido) {
                      // Si el login falla
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Usuario o contraseña incorrectos'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      // Si el login es exitoso, redirigir a la pantalla principal
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                const SizedBox(height: 12),

                // Botón Salir
                ElevatedButton(
                  onPressed: () {
                    exit(0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Salir',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
