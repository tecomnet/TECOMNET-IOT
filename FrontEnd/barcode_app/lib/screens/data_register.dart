import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import '../widgets/message_registro_exitoso.dart';
import '../widgets/menu_lateral.dart';

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

  @override
  void initState() {
    super.initState();
    _vinController = TextEditingController(text: widget.vinText);
    _simController = TextEditingController(text: widget.simText);
    
    // Agregar listeners para actualizar la UI cuando cambia el texto
    _vinController.addListener(() => setState(() {}));
    _simController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual, 
      overlays: SystemUiOverlay.values
    );
    
    // Remover listeners
    _vinController.removeListener(() {});
    _simController.removeListener(() {});
    
    _vinController.dispose();
    _simController.dispose();
    super.dispose();
  }

  void _registrar() {
    if (widget.vinText.isEmpty || widget.simText.isEmpty) {
      _mostrarError("Por favor, ingresa los datos requeridos");
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MessageExitoso(),
      ),
    );
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Función para determinar el color según si hay texto
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
          onTap: () => SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky),
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
                      
                      // Título "Registro"
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
                      
                      // Campo VIN - Sin negrita en ningún estado
                      TextField(
                        controller: _vinController,
                        readOnly: true,
                        style: TextStyle(
                          fontSize: 16,
                          color: _getColor(_vinController),
                          // Sin fontWeight (normal por defecto)
                        ),
                        decoration: InputDecoration(
                          labelText: 'Resultado VIN',
                          labelStyle: TextStyle(
                            color: _getColor(_vinController),
                            // Sin fontWeight (normal por defecto)
                          ),
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20
                          ),
                          filled: false,
                          prefixIcon: Icon(
                            Icons.qr_code_scanner, 
                            color: _getColor(_vinController),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _getColor(_vinController),
                              
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _getColor(_vinController),
                              
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Campo SIM - Sin negrita en ningún estado
                      TextField(
                        controller: _simController,
                        readOnly: true,
                        style: TextStyle(
                          fontSize: 16,
                          color: _getColor(_simController),
                          // Sin fontWeight (normal por defecto)
                        ),
                        decoration: InputDecoration(
                          labelText: 'Resultado SIM',
                          labelStyle: TextStyle(
                            color: _getColor(_simController),
                            // Sin fontWeight (normal por defecto)
                          ),
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20
                          ),
                          filled: false,
                          prefixIcon: Icon(
                            Icons.sim_card, 
                            color: _getColor(_simController),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _getColor(_simController),
                              
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _getColor(_simController),
                              
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Botón Registrar
                      Center(
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: _registrar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: azulActivo,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                              shadowColor: azulActivo.withOpacity(0.5),
                            ),
                            child: const Text(
                              'Registrar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
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