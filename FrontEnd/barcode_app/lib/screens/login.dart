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
  List<String> _usuariosGuardados = [];
  bool _mostrarContrasena = false;

  final Color azulActivo = Colors.blue[800]!;

  bool esCorreoValido(String correo) {
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$",
    ).hasMatch(correo);
  }

  @override
  void initState() {
    super.initState();
    _cargarUsuariosGuardados();
    usuarioController.addListener(() => setState(() {}));
    contrasenaController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    usuarioController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _cargarUsuariosGuardados() async {
    final prefs = await SharedPreferences.getInstance();
    final listaUsuarios = prefs.getStringList('usuarios_historicos') ?? [];
    setState(() {
      _usuariosGuardados = listaUsuarios;
    });
  }

  Future<void> _guardarUsuarioEnHistorial(String usuario) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> listaUsuarios = [..._usuariosGuardados];

    listaUsuarios.remove(usuario);
    listaUsuarios.insert(0, usuario);

    if (listaUsuarios.length > 5) {
      listaUsuarios = listaUsuarios.sublist(0, 5);
    }

    await prefs.setStringList('usuarios_historicos', listaUsuarios);
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

      print('UserID: $userId');

      // Paso 2: obtener token con credenciales fijas
      bool tokenObtenido = await AuthService.obtenerToken();

      if (!tokenObtenido) {
        _mostrarError('No se pudo obtener token');
        return;
      }

      await _guardarUsuarioEnHistorial(usuario);
      if (mounted)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: azulActivo,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'v14(1.0.0)', // aquí la versión estática
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFDF2F8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/icons/logo.png',
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                'Inicio de Sesión',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              Autocomplete<String>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return _usuariosGuardados;
                  }
                  return _usuariosGuardados.where((option) {
                    return option.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    );
                  });
                },
                onSelected: (selection) {
                  usuarioController.text = selection;
                },
                fieldViewBuilder:
                    (
                      context,
                      fieldController,
                      fieldFocusNode,
                      onFieldSubmitted,
                    ) {
                      fieldController.text = usuarioController.text;
                      return TextField(
                        controller: usuarioController,
                        focusNode: fieldFocusNode,
                        style: TextStyle(
                          color: usuarioController.text.isNotEmpty
                              ? azulActivo
                              : Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Usuario',
                          labelStyle: TextStyle(
                            color: usuarioController.text.isNotEmpty
                                ? azulActivo
                                : Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: azulActivo),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: usuarioController.text.isNotEmpty
                                ? azulActivo
                                : Colors.grey,
                          ),
                          floatingLabelStyle: TextStyle(color: azulActivo),
                        ),
                        onChanged: (value) => setState(() {}),
                      );
                    },
                optionsViewBuilder: (context, onSelected, options) {
                  final itemHeight = 48.0;
                  final maxHeight = 200.0;
                  final height = options.length * itemHeight > maxHeight
                      ? maxHeight
                      : options.length * itemHeight;

                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: Container(
                        constraints: BoxConstraints(maxHeight: height),
                        width: MediaQuery.of(context).size.width - 48,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return ListTile(
                              title: Text(option),
                              onTap: () {
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),

              TextField(
                controller: contrasenaController,
                obscureText: !_mostrarContrasena,
                style: TextStyle(
                  color: contrasenaController.text.isNotEmpty
                      ? azulActivo
                      : Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(
                    color: contrasenaController.text.isNotEmpty
                        ? azulActivo
                        : Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: contrasenaController.text.isNotEmpty
                        ? azulActivo
                        : Colors.grey,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: azulActivo),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _mostrarContrasena
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: contrasenaController.text.isNotEmpty
                          ? azulActivo
                          : Colors.grey,
                    ),
                    onPressed: () => setState(
                      () => _mostrarContrasena = !_mostrarContrasena,
                    ),
                  ),
                  floatingLabelStyle: TextStyle(color: azulActivo),
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _cargando ? null : _iniciarSesion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: azulActivo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _cargando
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text(
                        'Iniciar sesión',
                        style: TextStyle(fontSize: 20),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
