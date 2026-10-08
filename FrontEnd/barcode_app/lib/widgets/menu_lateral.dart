import 'package:flutter/material.dart';
import 'package:scannet_tecomnet/screens/registros_incompletos.dart';
import 'package:scannet_tecomnet/screens/scan_vin.dart';
import 'package:scannet_tecomnet/services/api_services.dart';
import 'package:scannet_tecomnet/widgets/dialogo_cerrar_sesion.dart';

class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  // Recibe el Navigator (no el context del drawer): el drawer se cierra antes
  // de mostrar el diálogo y su context deja de estar montado.
  Future<void> _confirmarCerrarSesion(NavigatorState navigator) async {
    final confirmado = await confirmarCerrarSesion(navigator.context);
    if (confirmado && navigator.mounted) {
      AuthService.logout();
      navigator.pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int userType = AuthService.userType ?? -1;

    final bool puedeVerTodo = userType == 2;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ---------- Encabezado ----------
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + 24,
              20,
              24,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[900]!, Colors.blue[600]!],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Scannet Tecomnet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Opciones de navegación',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // ---------- Opciones ----------
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              children: [
                _ItemMenu(
                  icono: Icons.qr_code_scanner_outlined,
                  titulo: 'Instalar',
                  color: Colors.blue[800]!,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ScanVin(vieneDeValidar: false),
                      ),
                    );
                  },
                ),
                if (puedeVerTodo)
                  _ItemMenu(
                    icono: Icons.fact_check_outlined,
                    titulo: 'Validar',
                    color: Colors.green[700]!,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ScanVin(vieneDeValidar: true),
                        ),
                      );
                    },
                  ),
                if (puedeVerTodo)
                  _ItemMenu(
                    icono: Icons.assignment_late_outlined,
                    titulo: 'Registros incompletos',
                    color: Colors.red[700]!,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrosIncompletos(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),

          // ---------- Cerrar sesión ----------
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _ItemMenu(
                icono: Icons.exit_to_app,
                titulo: 'Cerrar sesión',
                color: Colors.grey[800]!,
                onTap: () {
                  final navigator = Navigator.of(context);
                  navigator.pop(); // Cierra el drawer
                  _confirmarCerrarSesion(navigator);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemMenu extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final Color color;
  final VoidCallback onTap;

  const _ItemMenu({
    required this.icono,
    required this.titulo,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icono, color: color),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}
