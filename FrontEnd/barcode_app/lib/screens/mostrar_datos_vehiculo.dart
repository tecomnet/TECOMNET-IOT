import 'package:flutter/material.dart';
import 'package:scannet_tecomnet/screens/scan_vin.dart';
import 'package:scannet_tecomnet/widgets/menu_lateral.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:scannet_tecomnet/services/api_services.dart';

class MostrarDatosVehiculo extends StatefulWidget {
  final Map<String, dynamic>? vehiculoData;
  final bool? vieneRegistrosIncompletos;

  const MostrarDatosVehiculo({
    super.key,
    this.vehiculoData,
    this.vieneRegistrosIncompletos,
  });

  @override
  State<MostrarDatosVehiculo> createState() => _MostrarDatosVehiculoState();
}

class _MostrarDatosVehiculoState extends State<MostrarDatosVehiculo> {
  final ImagePicker _picker = ImagePicker();
  Map<String, String> _fotosBase64 = {};

  String? errorMensaje;

  bool _cargando = false;
  Map<String, dynamic>? _vehiculoData;

  Future<void> _takePhoto(String fieldKey) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 40,
        maxWidth: 900,
        maxHeight: 900,
      );

      if (photo == null) return;

      final bytes = await File(photo.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      setState(() {
        _cargando = true;
        _fotosBase64[fieldKey] = base64Image;
      });

      // Subir evidencia y obtener JSON actualizado
      final response = await _enviarEvidenciaUnica();

      if (response != null) {
        setState(() {
          _vehiculoData = response; // 🔹 actualizar todos los campos
          _fotosBase64[fieldKey] = base64Image; // 🔹 marcar foto subida
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al tomar/enviar foto'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _enviarEvidenciaUnica() async {
    if (errorMensaje != null) return null;

    final data = widget.vehiculoData;
    if (data == null) return null;

    final vin = (data['VIN'] ?? '').toString();
    if (vin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("VIN faltante, no se puede enviar evidencia"),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }

    final response = await AuthService.agregarEvidencias(
      vin: vin,
      iccid: (data['ICCID'] ?? '').toString(),
      versionAnterior: _fotosBase64['Version Anterior'] ?? '',
      versionActual: _fotosBase64['Version Actual'] ?? '',
      simAnterior: _fotosBase64['SIM Anterior'] ?? '',
      conectividad: _fotosBase64['Conectividad'] ?? '',
      estatusSim: (data['SIMStatus'] ?? '').toString(),
      estado: (data['State'] ?? '').toString(),
    );

    if (response['error'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['mensaje'] ?? 'Error al subir evidencia'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }

    return response; // ✅ devuelve el JSON actualizado
  }

  @override
  void initState() {
    super.initState();

    _vehiculoData = widget.vehiculoData;

    final data = widget.vehiculoData;

    if (data == null) {
      errorMensaje = "No existe el VIN";
      return;
    }

    final errorValue = data['error'];

    if (errorValue == true || errorValue == 'true' || errorValue == 1) {
      errorMensaje = data['mensaje'] ?? "No existe el VIN";
    }
  }

  Widget buildField(
    String label,
    String? value, {
    bool showCamera = false,
    VoidCallback? onCameraPressed,
  }) {
    final bool tieneFoto = _fotosBase64.containsKey(label);

    // Si hidePhotoName es true y hay foto, solo mostramos palomita
    final displayText = (!showCamera) ? (value ?? "") : "";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            (value != null && value.isNotEmpty) || tieneFoto
                ? Icons.check_circle
                : Icons.cancel,
            color: (value != null && value.isNotEmpty) || tieneFoto
                ? Colors.green
                : Colors.red,
          ),

          const SizedBox(width: 8),

          Text(
            displayText.isEmpty ? label : "$label: $displayText",
            style: const TextStyle(fontSize: 20),
          ),

          if (showCamera)
            IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.blue),
              onPressed: onCameraPressed,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos del vehiculo'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      endDrawer: const MenuLateral(),
      body: Stack(
        children: [
          // ================= CONTENIDO NORMAL =================
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (errorMensaje != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        errorMensaje!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  if (errorMensaje == null) ...[
                    buildField('VIN', _vehiculoData?['VIN']),
                    buildField('ICCID', _vehiculoData?['ICCID']),
                    const SizedBox(height: 30),

                    buildField(
                      'Version Anterior',
                      _vehiculoData?['PreviousVersion'],
                      showCamera: true,
                      onCameraPressed: _cargando
                          ? null
                          : () => _takePhoto('Version Anterior'),
                    ),
                    buildField(
                      'Version Actual',
                      _vehiculoData?['CurrentVersion'],
                      showCamera: true,
                      onCameraPressed: _cargando
                          ? null
                          : () => _takePhoto('Version Actual'),
                    ),
                    buildField(
                      'SIM Anterior',
                      _vehiculoData?['PreviousSIM'],
                      showCamera: true,
                      onCameraPressed: _cargando
                          ? null
                          : () => _takePhoto('SIM Anterior'),
                    ),
                    buildField(
                      'Conectividad',
                      _vehiculoData?['Connectivity'],
                      showCamera: true,
                      onCameraPressed: _cargando
                          ? null
                          : () => _takePhoto('Conectividad'),
                    ),

                    const SizedBox(height: 30),
                    buildField('Estatus SIM', _vehiculoData?['SIMStatus']),
                    buildField('Estado', _vehiculoData?['State']),
                  ],

                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _cargando
                        ? null
                        : () {
                            if (widget.vieneRegistrosIncompletos == true) {
                              // 🔙 Regresar a RegistrosIncompletos
                              Navigator.pop(context);
                            } else {
                              // 🔍 Ir a flujo normal
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ScanVin(vieneDeValidar: true),
                                ),
                              );
                            }
                          },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Buscar nuevo',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ================= OVERLAY PANTALLA COMPLETA =================
          if (_cargando)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.45),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
