import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static String? _token;
  static String? _email;
  static String? _password;

  static Future<bool> obtenerToken(String usuario, String clave) async {
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
        _token = response.body.replaceAll('"', '');
        _email = usuario;
        _password = clave;
        print('✅ Token recibido: $_token');
        return true;
      } else {
        print('Error al obtener token: ${response.statusCode}');
        print('Respuesta: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de conexión: $e');
      return false;
    }
  }

  static String? get token => _token;
}