import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService {

  static String? _token;
  static int? _userId;
  static int? _userType;

  static void logout() {
    _token = null;
    _userId = null;
    _userType = null;
  }

  static Future<int?> login(String usuario, String contrasena) async {
    logout(); // evita heredar sesión previa si este login falla
    final url = Uri.parse(
      'https://tecomnet.net/TECOMNET/APIDeveloper/api/User/Login/Installer',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"UserName": usuario, "Password": contrasena}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        _userId = data['_UserID'];
        _userType = data['_UserType'];
        return _userId;
      } else {
        debugPrint('❌ Error login: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error conexión: $e');
      return null;
    }
  }

  // 2. Obtener token con credenciales fijas (hardcoded)
  static Future<bool> obtenerToken() async {
    final url = Uri.parse(
      'https://tecomnet.net/TECOMNET/APIDeveloper/api/Account',
    );

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
        return true;
      } else {
        debugPrint('❌ Error al obtener token: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error de conexión: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> registrarVehiculo(
    String vin,
    String iccid,
  ) async {
    if (_token == null) {
      return {"error": true, "mensaje": "Token no disponible"};
    }

    if (_userId == null) {
      return {"error": true, "mensaje": "Usuario no autenticado"};
    }

    final url = Uri.parse(
      'https://tecomnet.net/TECOMNET/APIDeveloper/api/BYD/RegistrarVehiculo/VIN/$vin/ICCID/$iccid/UserID/$_userId',
    );

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
            },
          )
          .timeout(const Duration(seconds: 15));

      // 🔥 Éxito
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      // ❌ Error con cuerpo JSON
      try {
        final body = jsonDecode(response.body);
        return {"error": true, "mensaje": body["error"] ?? "Error inesperado"};
      } catch (_) {
        return {"error": true, "mensaje": "Error ${response.statusCode}"};
      }
    } catch (e) {
      return {"error": true, "mensaje": "Error de conexión"};
    }
  }

  static Future<Map<String, dynamic>> obtenerEstadoInstalacion(
    String vin,
  ) async {
    if (_token == null) {
      return {"error": true, "mensaje": "Token no disponible"};
    }

    final url = Uri.parse(
      'https://tecomnet.net/TECOMNET/APIDeveloper/api/BYD/ObtenerEstadoInstalacion/VIN/$vin',
    );

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        // Retornamos directamente los campos de la API
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      return {
        "error": true,
        "mensaje": "Error ${response.statusCode}: ${response.body}",
      };
    } catch (e) {
      return {"error": true, "mensaje": "Error de conexión: $e"};
    }
  }

  static Future<Map<String, dynamic>> agregarEvidencias({
    required String vin,
    required String iccid,
    required String versionAnterior,
    required String versionActual,
    required String simAnterior,
    required String conectividad,
    required String estatusSim,
    required String estado,
  }) async {
    if (_token == null) {
      return {"error": true, "mensaje": "Token no disponible"};
    }

    final url = Uri.parse(
      'https://tecomnet.net/TECOMNET/APIDeveloper/api/BYD/AsociarEvidenciaInstalacion',
    );

    final body = {
      "VIN": vin.trim().toUpperCase(),
      "ICCID": iccid.trim(),
      "PreviousVersion": versionAnterior.trim(),
      "CurrentVersion": versionActual.trim(),
      "PreviousSIM": simAnterior.trim(),
      "Connectivity": conectividad.trim(),
      "SIMStatus": estatusSim.trim(),
      "State": estado.trim(),
    };

    try {
      final response = await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      return {
        "error": true,
        "mensaje": "Error ${response.statusCode}: ${response.body}",
      };
    } catch (e) {
      return {"error": true, "mensaje": "Error de conexión: $e"};
    }
  }

  static Future<Map<String, dynamic>> obtenerRegistrosIncompletos(
    DateTime fecha,
  ) async {
    if (_token == null) {
      return {"error": true, "mensaje": "Token no disponible"};
    }

    final fechaFormateada =
        "${fecha.year.toString().padLeft(4, '0')}-"
        "${fecha.month.toString().padLeft(2, '0')}-"
        "${fecha.day.toString().padLeft(2, '0')}";

    final url = Uri.parse(
      'https://tecomnet.net/TECOMNET/APIDeveloper/api/BYD/ObtenerEvidencias/$fechaFormateada',
    );

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
            },
          )
          .timeout(const Duration(seconds: 15));

if (response.statusCode == 204) {
      return {
        "error": false,
        "sinRegistros": true,
        "registros": [],
      };
    }
    
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // 🔥 EL BACKEND DEVUELVE UNA LISTA
        if (decoded is List) {
          return {"error": false, "registros": decoded};
        }

        // Por si algún día cambia
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }

        return {"error": true, "mensaje": "Formato de respuesta no soportado"};
      }

      return {
        "error": true,
        "mensaje": "Error ${response.statusCode}: ${response.body}",
      };
    } catch (e) {
      return {"error": true, "mensaje": "Error de conexión: $e"};
    }
  }

  static String? get token => _token;
  static int? get userId => _userId;
  static int? get userType => _userType;
}
