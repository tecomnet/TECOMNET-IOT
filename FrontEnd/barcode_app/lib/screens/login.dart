import 'package:flutter/material.dart';
import 'package:scannet_tecomnet/screens/home.dart';
import 'package:scannet_tecomnet/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  bool _cargando = false;
  bool _mostrarContrasena = false;
  bool _recordarUsuario = false;

  final Color azulActivo = Colors.blue[800]!;

  bool esCorreoValido(String correo) {
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$",
    ).hasMatch(correo);
  }

  @override
  void initState() {
    super.initState();
    _cargarUsuarioRecordado();
    usuarioController.addListener(() => setState(() {}));
    contrasenaController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    usuarioController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _cargarUsuarioRecordado() async {
    final prefs = await SharedPreferences.getInstance();
    // Limpia el historial de correos de versiones anteriores
    await prefs.remove('usuarios_historicos');
    final recordar = prefs.getBool('recordar_usuario') ?? false;
    final usuarioRecordado = prefs.getString('usuario_recordado') ?? '';
    if (!mounted) return;
    setState(() => _recordarUsuario = recordar);
    if (recordar && usuarioRecordado.isNotEmpty) {
      usuarioController.text = usuarioRecordado;
    }
  }

  // Guarda o borra el usuario recordado según el estado del checkbox
  Future<void> _actualizarUsuarioRecordado(String usuario) async {
    final prefs = await SharedPreferences.getInstance();
    if (_recordarUsuario) {
      await prefs.setBool('recordar_usuario', true);
      await prefs.setString('usuario_recordado', usuario);
    } else {
      await prefs.remove('recordar_usuario');
      await prefs.remove('usuario_recordado');
    }
  }

  Future<void> _iniciarSesion() async {
    FocusScope.of(context).unfocus();
    setState(() => _cargando = true);

    final usuario = usuarioController.text.trim();
    final contrasena = contrasenaController.text.trim();

    if (usuario.isEmpty || contrasena.isEmpty) {
      _mostrarError('Por favor, ingresa tus datos');
      setState(() => _cargando = false);
      return;
    }

    if (!esCorreoValido(usuario)) {
      _mostrarError('Ingresa un correo válido');
      return;
    }

    try {
      // Paso 1: validar usuario real (installer@tecomnet.net)
      final int? userId = await AuthService.login(usuario, contrasena);

      if (userId == null) {
        _mostrarError('Usuario o contraseña incorrectos');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', userId);

      // Paso 2: obtener token con credenciales fijas
      bool tokenObtenido = await AuthService.obtenerToken();

      if (!tokenObtenido) {
        _mostrarError('No se pudo obtener token');
        return;
      }

      await _actualizarUsuarioRecordado(usuario);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } catch (e) {
      _mostrarError('Error de conexión: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _mostrarError(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: mensaje.contains('Ingresa')
            ? Colors.orange
            : Colors.red,
      ),
    );
    setState(() => _cargando = false);
  }

  InputDecoration _decoracion({
    required String label,
    required IconData icono,
    required bool lleno,
    Widget? sufijo,
  }) {
    final Color colorIcono = lleno ? azulActivo : Colors.grey;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: lleno ? azulActivo : Colors.grey[600]),
      floatingLabelStyle: TextStyle(color: azulActivo),
      prefixIcon: Icon(icono, color: colorIcono),
      suffixIcon: sufijo,
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
        borderSide: BorderSide(color: azulActivo, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[900]!, Colors.blue[700]!, Colors.blue[400]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ---------- Logo ----------
                    Image.asset(
                      'assets/icons/Logo_Azul.png',
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Scannet Tecomnet',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Registro de vehículos',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 28),

                    // ---------- Tarjeta del formulario ----------
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
                          Text(
                            'Inicio de sesión',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: azulActivo,
                            ),
                          ),
                          const SizedBox(height: 24),

                          TextField(
                            controller: usuarioController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                              color: usuarioController.text.isNotEmpty
                                  ? azulActivo
                                  : Colors.black,
                            ),
                            decoration: _decoracion(
                              label: 'Usuario',
                              icono: Icons.person,
                              lleno: usuarioController.text.isNotEmpty,
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextField(
                            controller: contrasenaController,
                            obscureText: !_mostrarContrasena,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              if (!_cargando) _iniciarSesion();
                            },
                            style: TextStyle(
                              color: contrasenaController.text.isNotEmpty
                                  ? azulActivo
                                  : Colors.black,
                            ),
                            decoration: _decoracion(
                              label: 'Contraseña',
                              icono: Icons.lock,
                              lleno: contrasenaController.text.isNotEmpty,
                              sufijo: IconButton(
                                icon: Icon(
                                  _mostrarContrasena
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: contrasenaController.text.isNotEmpty
                                      ? azulActivo
                                      : Colors.grey,
                                ),
                                onPressed: () => setState(
                                  () =>
                                      _mostrarContrasena = !_mostrarContrasena,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          Center(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: _cargando
                                  ? null
                                  : () => setState(
                                      () =>
                                          _recordarUsuario = !_recordarUsuario,
                                    ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: _recordarUsuario,
                                      activeColor: azulActivo,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      onChanged: _cargando
                                          ? null
                                          : (v) => setState(
                                              () =>
                                                  _recordarUsuario = v ?? false,
                                            ),
                                    ),
                                    Text(
                                      'Recordar usuario',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _cargando ? null : _iniciarSesion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: azulActivo,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.blue[300],
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _cargando
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      'Iniciar sesión',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'v14 (1.0.0)',
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
