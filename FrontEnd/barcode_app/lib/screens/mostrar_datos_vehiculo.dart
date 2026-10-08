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
  final Map<String, String> _fotosBase64 = {};

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

      if (!mounted) return;
      if (response != null) {
        setState(() {
          _vehiculoData = response; // 🔹 actualizar todos los campos
          _fotosBase64[fieldKey] = base64Image; // 🔹 marcar foto subida
        });
      } else {
        // La subida falló: no marcar la foto como enviada
        setState(() => _fotosBase64.remove(fieldKey));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _fotosBase64.remove(fieldKey));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al tomar/enviar foto'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  Future<Map<String, dynamic>?> _enviarEvidenciaUnica() async {
    if (errorMensaje != null) return null;

    // Estado más reciente (se actualiza tras cada subida exitosa)
    final data = _vehiculoData;
    if (data == null) return null;

    // Foto tomada en esta sesión; si no hay, se conserva lo que ya devolvió el servidor
    String evidencia(String foto, String campo) =>
        _fotosBase64[foto] ?? (data[campo] ?? '').toString();

    final vin = (data['VIN'] ?? '').toString();
    if (vin.isEmpty) {
      if (!mounted) return null;
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
      versionAnterior: evidencia('Version Anterior', 'PreviousVersion'),
      versionActual: evidencia('Version Actual', 'CurrentVersion'),
      simAnterior: evidencia('SIM Anterior', 'PreviousSIM'),
      conectividad: evidencia('Conectividad', 'Connectivity'),
      estatusSim: (data['SIMStatus'] ?? '').toString(),
      estado: (data['State'] ?? '').toString(),
    );

    if (!mounted) return null;
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

  // Fila de solo lectura (VIN, ICCID, estatus, estado)
  Widget _filaDato(IconData icono, String label, String? value) {
    final bool tieneValor = value != null && value.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icono, color: Colors.blue[800], size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  tieneValor ? value : 'Sin dato',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: tieneValor ? Colors.black87 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fila de evidencia con estado (completa / pendiente) y botón de cámara
  Widget _filaEvidencia(String label, String? value) {
    final bool completa =
        (value != null && value.isNotEmpty) || _fotosBase64.containsKey(label);
    final Color color = completa ? Colors.green[700]! : Colors.red[700]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            completa ? Icons.check_circle : Icons.cancel,
            color: color,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  completa ? 'Evidencia cargada' : 'Pendiente',
                  style: TextStyle(fontSize: 13, color: color),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue[50],
              foregroundColor: Colors.blue[800],
            ),
            icon: const Icon(Icons.camera_alt),
            tooltip: completa ? 'Volver a tomar' : 'Tomar foto',
            onPressed: _cargando ? null : () => _takePhoto(label),
          ),
        ],
      ),
    );
  }

  Widget _tarjeta({
    required String titulo,
    required IconData icono,
    required List<Widget> hijos,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, color: Colors.blue[800]),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...hijos,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Datos del vehículo'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      endDrawer: const MenuLateral(),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue[900]!,
                  Colors.blue[700]!,
                  Colors.blue[400]!,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (errorMensaje != null)
                          _tarjeta(
                            titulo: 'Sin resultados',
                            icono: Icons.error_outline,
                            hijos: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text(
                                  errorMensaje!,
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        else ...[
                          _tarjeta(
                            titulo: 'Vehículo',
                            icono: Icons.directions_car,
                            hijos: [
                              _filaDato(
                                Icons.pin,
                                'VIN',
                                _vehiculoData?['VIN']?.toString(),
                              ),
                              _filaDato(
                                Icons.sim_card,
                                'ICCID',
                                _vehiculoData?['ICCID']?.toString(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _tarjeta(
                            titulo: 'Evidencias',
                            icono: Icons.photo_camera_back,
                            hijos: [
                              _filaEvidencia(
                                'Version Anterior',
                                _vehiculoData?['PreviousVersion']?.toString(),
                              ),
                              _filaEvidencia(
                                'Version Actual',
                                _vehiculoData?['CurrentVersion']?.toString(),
                              ),
                              _filaEvidencia(
                                'SIM Anterior',
                                _vehiculoData?['PreviousSIM']?.toString(),
                              ),
                              _filaEvidencia(
                                'Conectividad',
                                _vehiculoData?['Connectivity']?.toString(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _tarjeta(
                            titulo: 'Estado',
                            icono: Icons.info_outline,
                            hijos: [
                              _filaDato(
                                Icons.sim_card_alert,
                                'Estatus SIM',
                                _vehiculoData?['SIMStatus']?.toString(),
                              ),
                              _filaDato(
                                Icons.flag,
                                'Estado',
                                _vehiculoData?['State']?.toString(),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: _cargando
                                ? null
                                : () {
                                    if (widget.vieneRegistrosIncompletos ==
                                        true) {
                                      // 🔙 Regresar a RegistrosIncompletos
                                      Navigator.pop(context);
                                    } else {
                                      // 🔍 Ir a flujo normal
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ScanVin(
                                                vieneDeValidar: true,
                                              ),
                                        ),
                                      );
                                    }
                                  },
                            icon: const Icon(Icons.search),
                            label: const Text(
                              'Buscar nuevo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue[800],
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ================= OVERLAY PANTALLA COMPLETA =================
          if (_cargando)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.45),
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
