import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static String? _token;
  static String? _email;
  static String? _password;

  // Obtiene token con credenciales fijas, guarda token y usuario
  static Future<bool> obtenerToken(String usuario, String clave) async {
    final url = Uri.parse('https://tecomnet.net/TECOMNET/APIDeveloper/api/Account');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "UserName": "BYD.TECOMNET.USER_API", // credenciales fijas
          "Password": "VnhmNTk4ZW44NHAy",
        }),
      );

      if (response.statusCode == 200) {
        _token = response.body.replaceAll('"', '');
        _email = usuario;
        _password = clave;
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

  // Método para registrar vehículo usando token guardado
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

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // En caso de error también devolvemos el cuerpo para analizarlo
        return response.body;
      }
    } catch (e) {
      print('Error en el registro del vehículo: $e');
      return null;
    }
  }

  static String? get token => _token;
}
