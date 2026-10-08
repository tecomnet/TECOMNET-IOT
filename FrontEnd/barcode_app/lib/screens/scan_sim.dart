import 'package:flutter/material.dart';
import 'package:scannet_tecomnet/screens/scan_barcode.dart';
import 'package:scannet_tecomnet/screens/scan_ocr.dart';
import '../widgets/menu_lateral.dart';

class ScanSim extends StatefulWidget {
  final String? vinText; // Texto del VIN escaneado previamente

  const ScanSim({super.key, this.vinText});

  @override
  State<ScanSim> createState() => _ScanSimState();
}

class _ScanSimState extends State<ScanSim> {
  String _selectedOption = 'Barcode';

  void _navigateToScan() {
    if (_selectedOption == 'Barcode') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanBarcode(vinText: widget.vinText),
        ),
      );
    } else if (_selectedOption == 'OCR') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanOcr(vinText: widget.vinText),
          settings: const RouteSettings(arguments: {'origen': 'sim'}),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vin = widget.vinText;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Escaneo SIM'),
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
                        Icons.sim_card,
                        size: 56,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Escanea la SIM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                    if (vin != null && vin.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.directions_car,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'VIN: $vin',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),

                    _OpcionEscaneo(
                      icono: Icons.barcode_reader,
                      titulo: 'Barcode',
                      descripcion: 'Lee el código de barras de la SIM',
                      seleccionada: _selectedOption == 'Barcode',
                      onTap: () => setState(() => _selectedOption = 'Barcode'),
                    ),
                    const SizedBox(height: 14),
                    _OpcionEscaneo(
                      icono: Icons.text_fields,
                      titulo: 'OCR',
                      descripcion: 'Reconoce el número impreso con la cámara',
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
