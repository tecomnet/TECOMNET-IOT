import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/menu_lateral.dart';
import '../services/api_services.dart';  // Asegúrate de importar tu servicio

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

  final Color azulActivo = Colors.blue[800]!;
  final Color grisInactivo = Colors.grey;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _vinController = TextEditingController(text: widget.vinText);
    _simController = TextEditingController(text: widget.simText);

    _vinController.addListener(() => setState(() {}));
    _simController.addListener(() => setState(() {}));
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

    if (AuthService.token == null) {
      bool tokenObtenido = await AuthService.obtenerToken(
          "BYD.TECOMNET.USER_API", "VnhmNTk4ZW44NHAy");
      if (!tokenObtenido) {
        setState(() {
          _isLoading = false;
        });
        _mostrarError("No se pudo obtener el token. Intenta más tarde.");
        return;
      }
    }

    final respuesta = await AuthService.registrarVehiculo(vin, iccid);

    setState(() {
      _isLoading = false;
    });

    if (respuesta == null) {
      _mostrarError("Error en la conexión. Intenta más tarde.");
      return;
    }

    // Mostrar respuesta que viene directamente del API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(respuesta),
        backgroundColor: (respuesta.toLowerCase().contains("error") ||
                respuesta.toLowerCase().contains("no existe") ||
                respuesta.toLowerCase().contains("ya registrado") ||
                respuesta.toLowerCase().contains("asociado"))
            ? Colors.red
            : Colors.green,
        duration: const Duration(seconds: 4),
      ),
    );

    // NO NAVEGAMOS NI MOSTRAMOS OTRO MENSAJE EXITOSO, solo el SnackBar aquí.
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Color _getColor(TextEditingController controller) {
    return controller.text.isEmpty ? grisInactivo : azulActivo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulActivo,
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
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Registro',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _vinController,
                        readOnly: true,
                        style: TextStyle(
                          fontSize: 16,
                          color: _getColor(_vinController),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Resultado VIN',
                          labelStyle: TextStyle(
                            color: _getColor(_vinController),
                          ),
                          border: const OutlineInputBorder(),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          prefixIcon: Icon(Icons.qr_code_scanner,
                              color: _getColor(_vinController)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: _getColor(_vinController)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: _getColor(_vinController)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _simController,
                        readOnly: true,
                        style: TextStyle(
                          fontSize: 16,
                          color: _getColor(_simController),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Resultado SIM',
                          labelStyle: TextStyle(
                            color: _getColor(_simController),
                          ),
                          border: const OutlineInputBorder(),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          prefixIcon: Icon(Icons.sim_card, color: _getColor(_simController)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: _getColor(_simController)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: _getColor(_simController)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Center(
                        child: SizedBox(
                          width: 200,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _registrar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: azulActivo,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                              shadowColor: azulActivo.withOpacity(0.5),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Registrar',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
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
