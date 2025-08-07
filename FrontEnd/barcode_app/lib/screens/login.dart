import 'package:flutter/material.dart';
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
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$")
        .hasMatch(correo);
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

    print('Usuario ingresado: "$usuario"');
    print('Contraseña ingresada: "$contrasena"');

    if (usuario.isEmpty || contrasena.isEmpty) {
      _mostrarError('Por favor, ingresa tus datos');
      return;
    }

    if (!esCorreoValido(usuario)) {
      _mostrarError('Ingresa un correo válido');
      return;
    }

    try {
      final tokenObtenido = await AuthService.obtenerToken(usuario, contrasena);

      if (!tokenObtenido) {
        _mostrarError('Usuario o contraseña incorrectos');
      } else {
        await _guardarUsuarioEnHistorial(usuario);
        if (mounted) Navigator.pushReplacementNamed(context, '/start');
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
        backgroundColor: mensaje.contains('Ingresa') ? Colors.orange : Colors.red,
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
      ),
      backgroundColor: const Color(0xFFFDF2F8),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Inicio de sesión',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                Autocomplete<String>(
                  optionsBuilder: (textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return _usuariosGuardados;
                    }
                    return _usuariosGuardados.where((option) {
                      return option.toLowerCase().contains(
                          textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (selection) {
                    usuarioController.text = selection;
                  },
                  fieldViewBuilder: (
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
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: azulActivo),
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
                  optionsViewBuilder: (
                    context,
                    onSelected,
                    options,
                  ) {
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
                          constraints: BoxConstraints(
                            maxHeight: height,
                          ),
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
                const SizedBox(height: 16),

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
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: contrasenaController.text.isNotEmpty
                          ? azulActivo
                          : Colors.grey,
                    ),
                    focusedBorder: OutlineInputBorder(
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
                      onPressed: () => setState(() =>
                          _mostrarContrasena = !_mostrarContrasena),
                    ),
                    floatingLabelStyle: TextStyle(color: azulActivo),
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _cargando ? null : _iniciarSesion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azulActivo,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
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
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
