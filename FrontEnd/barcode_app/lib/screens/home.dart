import 'package:flutter/material.dart';
import 'package:scannet_tecomnet/screens/registros_incompletos.dart';
import 'package:scannet_tecomnet/screens/scan_vin.dart';
import 'package:scannet_tecomnet/services/api_services.dart';
import 'package:scannet_tecomnet/widgets/dialogo_cerrar_sesion.dart';
import 'package:scannet_tecomnet/widgets/menu_lateral.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Future<void> _confirmarSalida(BuildContext context) async {
    final confirmado = await confirmarCerrarSesion(context);

    if (confirmado && context.mounted) {
      AuthService.logout();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mismo criterio que el menú lateral: el rol 2 ve todas las opciones
    final bool puedeVerTodo = (AuthService.userType ?? -1) == 2;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmarSalida(context);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        endDrawer: const MenuLateral(),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/Logo_Azul.png',
                        height: 130,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Bienvenido',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Registro de vehículos',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 32),

                      _OpcionHome(
                        icono: Icons.qr_code_scanner,
                        titulo: 'Instalar',
                        descripcion: 'Vincular un VIN con su SIM',
                        color: Colors.blue[800]!,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ScanVin(vieneDeValidar: false),
                          ),
                        ),
                      ),
                      if (puedeVerTodo) ...[
                        const SizedBox(height: 16),
                        _OpcionHome(
                          icono: Icons.fact_check,
                          titulo: 'Validar',
                          descripcion: 'Consultar el estado de un VIN',
                          color: Colors.green[700]!,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ScanVin(vieneDeValidar: true),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _OpcionHome(
                          icono: Icons.assignment_late,
                          titulo: 'Registros incompletos',
                          descripcion: 'Completar evidencias por fecha',
                          color: Colors.red[700]!,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegistrosIncompletos(),
                            ),
                          ),
                        ),
                      ],
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

class _OpcionHome extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String descripcion;
  final Color color;
  final VoidCallback onTap;

  const _OpcionHome({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 6,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icono, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      descripcion,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[500]),
            ],
          ),
        ),
      ),
    );
  }
}
