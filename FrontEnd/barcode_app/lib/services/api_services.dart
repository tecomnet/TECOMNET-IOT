import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static String? _token;

  // 1. Validar usuario real (installer)
  static Future<bool> validarUsuarioReal(String usuario, String contrasena) async {
    final url = Uri.parse('https://tecomnet.net/TECOMNET/APIDeveloper/api/User/Login/Installer');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "UserName": usuario,
          "Password": contrasena,
        }),
      );

      // Retorna true si la respuesta es 200, false en otro caso
      return response.statusCode == 200;
    } catch (e) {
      print('Error validar usuario real: $e');
      return false;
    }
  }

  // 2. Obtener token con credenciales fijas (hardcoded)
  static Future<bool> obtenerToken() async {
    final url = Uri.parse('https://tecomnet.net/TECOMNET/APIDeveloper/api/Account');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "UserName": "BYD.TECOMNET.USER_API",
          "Password": "VnhmNTk4ZW44NHAy",
        }),
      );

      if (response.statusCode == 200) {
        // El token viene como string con comillas, las quitamos
        _token = response.body.replaceAll('"', '');
        print('✅ Token recibido: $_token');
        return true;
      } else {
        print('❌ Error al obtener token: ${response.statusCode}');
        print('Respuesta: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error de conexión: $e');
      return false;
    }
  }

  // 3. Registrar vehículo usando token previamente obtenido
  static Future<String?> registrarVehiculo(String vin, String iccid) async {
    if (_token == null) {
      print('⚠️ Token no disponible. Por favor, llama a obtenerToken primero.');
      return null;
    }

    final url = Uri.parse(
      'https://tecomnet.net/TECOMNET/APIDeveloper/api/BYD/RegistrarVehiculo/VIN/$vin/ICCID/$iccid',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      // Retornamos el cuerpo siempre, sea status 200 o no para análisis posterior
      return response.body;
    } catch (e) {
      print('Error en el registro del vehículo: $e');
      return null;
    }
  }

  // Getter para acceder al token actual
  static String? get token => _token;
}
