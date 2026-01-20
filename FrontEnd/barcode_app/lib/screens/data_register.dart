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
      if (!tokenObtenido) {
        setState(() {
          _isLoading = false;
        });
        _mostrarError("No se pudo obtener el token. Intenta más tarde.");
        return;
      }
    }

    final respuestaJson = await AuthService.registrarVehiculo(vin, iccid);
    debugPrint(respuestaJson.toString());

    setState(() {
      _isLoading = false;
      _showBackButton = true;
    });

    if (respuestaJson == null) {
      _mostrarError("Error en la conexión. Intenta más tarde.");
      return;
    }

    final Map<String, dynamic> data = respuestaJson;

final bool esError = data["error"] == true;
final String mensaje =
    data["mensaje"] ?? "El vehículo se registró correctamente";


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 5), // ← 5 segundos
      ),
    );
  }

  // -------------------- BUILD --------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
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
            margin: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 50,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),

                  child: Column(
                    children: [
                      Text(
                        'Vinculación',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'VIN',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _vinController,
                        readOnly: true,
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          prefixIcon: Icon(Icons.qr_code_scanner),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'SIM',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _simController,
                        readOnly: true,
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          prefixIcon: Icon(Icons.sim_card),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      Center(
                        child: SizedBox(
                          width: 200,
                          height: 48,
                          child: _showBackButton
                              ? ElevatedButton(
                                  onPressed: _volverAScanner,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[800],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 50,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: const Text(
                                    'Nueva',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: _isLoading ? null : _registrar,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[800],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 50,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          'Vincular',
                                          style: TextStyle(fontSize: 20),
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
      ),
    );
  }
}
