import 'package:flutter/material.dart';
import '../widgets/menu_lateral.dart';
import 'scan_ocr.dart';
import 'scan_qr.dart';

class ScanVin extends StatefulWidget {
  final bool vieneDeValidar;
  const ScanVin({super.key, this.vieneDeValidar = false});

  @override
  State<ScanVin> createState() => _ScanVinState();
}

class _ScanVinState extends State<ScanVin> {
  String _selectedOption = 'QR';

  void _navigateToScan() {
    if (_selectedOption == 'OCR') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanOcr(vieneDeValidar: widget.vieneDeValidar),
        ),
      );
    } else if (_selectedOption == 'QR') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanQR(vieneDeValidar: widget.vieneDeValidar),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('ScanVin vieneDeValidar: ${widget.vieneDeValidar}');
  }

  @override
  Widget build(BuildContext context) {
    final bool desdeValidar = widget.vieneDeValidar;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(desdeValidar ? 'Búsqueda por VIN' : 'Escaneo VIN'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                        Icons.directions_car,
                        size: 56,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      desdeValidar
                          ? 'Buscar un vehículo'
                          : 'Escanea el VIN del vehículo',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Selecciona el tipo de escaneo',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 28),

                    _OpcionEscaneo(
                      icono: Icons.qr_code_2,
                      titulo: 'QR',
                      descripcion: 'Lee el código QR del vehículo',
                      seleccionada: _selectedOption == 'QR',
                      onTap: () => setState(() => _selectedOption = 'QR'),
                    ),
                    const SizedBox(height: 14),
                    _OpcionEscaneo(
                      icono: Icons.text_fields,
                      titulo: 'OCR',
                      descripcion: 'Reconoce el VIN impreso con la cámara',
                      seleccionada: _selectedOption == 'OCR',
                      onTap: () => setState(() => _selectedOption = 'OCR'),
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _navigateToScan,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text(
                          'Siguiente',
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
    );
  }
}

class _OpcionEscaneo extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String descripcion;
  final bool seleccionada;
  final VoidCallback onTap;

  const _OpcionEscaneo({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.seleccionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color azul = Colors.blue[800]!;

    return Material(
      color: Colors.white,
      elevation: seleccionada ? 8 : 2,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: seleccionada ? azul : Colors.transparent,
              width: 2.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: azul.withValues(alpha: seleccionada ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icono, color: azul, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: azul,
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
              Icon(
                seleccionada ? Icons.check_circle : Icons.radio_button_unchecked,
                color: seleccionada ? azul : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
