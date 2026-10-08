// IMPORTANTE para jsonDecode
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scannet_tecomnet/screens/scan_vin.dart';
import '../widgets/menu_lateral.dart';
import '../services/api_services.dart'; // Aquí debe estar la clase AuthService

class DataRegister extends StatefulWidget {
  final String vinText;
  final String simText;
  final String? extractedText;

  const DataRegister({
    super.key,
    required this.vinText,
    required this.simText,
    this.extractedText,
  });

  @override
  State<DataRegister> createState() => _DataRegisterState();
}

class _DataRegisterState extends State<DataRegister> {
  late final TextEditingController _vinController;
  late final TextEditingController _simController;

  bool _isLoading = false;
  bool _showBackButton = false;

  @override
  void initState() {
    super.initState();
    _vinController = TextEditingController(text: widget.vinText);
    _simController = TextEditingController(text: widget.simText);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    _vinController.dispose();
    _simController.dispose();
    super.dispose();
  }

  void _volverAScanner() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ScanVin(vieneDeValidar: false)));
  }

  // -------------------- MÉTODO DE ERROR --------------------
  void _mostrarError(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
    setState(() {
      _showBackButton = true;
    });
  }

  // -------------------- MÉTODO REGISTRAR --------------------
  Future<void> _registrar() async {
    if (_vinController.text.isEmpty || _simController.text.isEmpty) {
      _mostrarError("Por favor, ingresa los datos requeridos");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final vin = _vinController.text.trim();
    final iccid = _simController.text.trim();

    // Obtener token si no existe
    if (AuthService.token == null) {
      bool tokenObtenido = await AuthService.obtenerToken();
      if (!mounted) return;
      if (!tokenObtenido) {
        setState(() {
          _isLoading = false;
        });
        _mostrarError("No se pudo obtener el token. Intenta más tarde.");
        return;
      }
    }

    final respuestaJson = await AuthService.registrarVehiculo(vin, iccid);
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _showBackButton = true;
    });

    final bool esError = respuestaJson["error"] == true;
    final String mensaje =
        respuestaJson["mensaje"] ?? "El vehículo se registró correctamente";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 5), // ← 5 segundos
      ),
    );
  }

  // -------------------- BUILD --------------------
  Widget _campoSoloLectura({
    required String label,
    required IconData icono,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            prefixIcon: Icon(icono, color: Colors.blue[800]),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.blue.shade300),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Vinculación'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      endDrawer: const MenuLateral(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        child: GestureDetector(
          onTap: () =>
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky),
          child: Container(
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
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.link,
                            size: 56,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Vincular VIN y SIM',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Verifica los datos antes de vincular',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        const SizedBox(height: 28),

                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _campoSoloLectura(
                                label: 'VIN',
                                icono: Icons.qr_code_scanner,
                                controller: _vinController,
                              ),
                              const SizedBox(height: 20),
                              _campoSoloLectura(
                                label: 'SIM',
                                icono: Icons.sim_card,
                                controller: _simController,
                              ),
                              const SizedBox(height: 28),
                              SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _showBackButton
                                      ? _volverAScanner
                                      : (_isLoading ? null : _registrar),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[800],
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.blue[300],
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : Text(
                                          _showBackButton ? 'Nueva' : 'Vincular',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
