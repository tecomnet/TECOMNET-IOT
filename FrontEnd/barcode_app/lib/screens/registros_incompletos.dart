import 'package:flutter/material.dart';
import 'package:scannet_tecomnet/screens/mostrar_datos_vehiculo.dart';
import 'package:scannet_tecomnet/services/api_services.dart';
import '../widgets/menu_lateral.dart';

class RegistrosIncompletos extends StatefulWidget {
  final bool vieneDeValidar;
  const RegistrosIncompletos({super.key, this.vieneDeValidar = false});

  @override
  State<RegistrosIncompletos> createState() => _RegistrosIncompletosState();
}

class _RegistrosIncompletosState extends State<RegistrosIncompletos> {
  late DateTime _fechaSeleccionada;
  final TextEditingController _fechaController = TextEditingController();

  List<Map<String, String>> registrosIncompletos = [];
  bool isLoading = true;
  String? mensajeSinRegistros;

  Future<void> _cargarRegistros() async {
    setState(() {
      isLoading = true;
      mensajeSinRegistros = null;
      registrosIncompletos.clear();
    });

    print('📅 Fecha seleccionada (DateTime): $_fechaSeleccionada');

    final fechaFormateada =
        "${_fechaSeleccionada.year.toString().padLeft(4, '0')}-"
        "${_fechaSeleccionada.month.toString().padLeft(2, '0')}-"
        "${_fechaSeleccionada.day.toString().padLeft(2, '0')}";

    print('📅 Fecha que se enviará al API: $fechaFormateada');

    final result = await AuthService.obtenerRegistrosIncompletos(
      _fechaSeleccionada,
    );

    if (!mounted) return;

    if (result['error'] == true) {
      // Manejar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['mensaje'] ?? 'Error al obtener registros'),
        ),
      );
    } else if (result['sinRegistros'] == true) {
      setState(() {
        mensajeSinRegistros = "En esa fecha no hubo registro de VIN";
      });
    } else {
      // Suponiendo que la API devuelve algo como {"registros":[{"vin":"...","usuario":"..."}]}
      final List<dynamic> lista = result['registros'] ?? [];
      registrosIncompletos = lista.map<Map<String, String>>((item) {
        return {
          'vin': item['VIN'].toString(),
          'usuario': item['Usuario'].toString(),
        };
      }).toList();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fechaSeleccionada = DateTime.now();
    _fechaController.text =
        "${_fechaSeleccionada.day.toString().padLeft(2, '0')}/"
        "${_fechaSeleccionada.month.toString().padLeft(2, '0')}/"
        "${_fechaSeleccionada.year}";

    _cargarRegistros();
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'SELECCIONA LA FECHA',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      builder: (context, child) {
        final azul = Colors.blue[800]!;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: azul, // encabezado y día seleccionado
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              headerBackgroundColor: azul,
              headerForegroundColor: Colors.white,
              todayBorder: BorderSide(color: azul),
              todayForegroundColor: WidgetStatePropertyAll(azul),
              dayShape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: azul,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fechaSeleccionada = picked;
        _fechaController.text =
            "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });

      _cargarRegistros();
    }
  }

  @override
  void dispose() {
    _fechaController.dispose();
    super.dispose();
  }

  bool _abriendoRegistro = false;

  Future<void> _abrirRegistro(String vin) async {
    setState(() => _abriendoRegistro = true);

    // 🔄 Llamada al API
    final response = await AuthService.obtenerEstadoInstalacion(vin);

    if (!mounted) return;
    setState(() => _abriendoRegistro = false);

    if (response['error'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['mensaje'] ?? 'Error al obtener datos'),
        ),
      );
      return;
    }

    // 🚀 Navegación con JSON completo
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MostrarDatosVehiculo(
          vehiculoData: response,
          vieneRegistrosIncompletos: true,
        ),
      ),
    );
  }

  Widget _tabla() {
    const estiloEncabezado = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(Colors.blue[800]),
            headingRowHeight: 56,
            dataRowMinHeight: 56,
            dataRowMaxHeight: 56,
            columnSpacing: 28,
            horizontalMargin: 20,
            dividerThickness: 0.8,
            columns: const [
              DataColumn(label: Text('VIN', style: estiloEncabezado)),
              DataColumn(label: Text('Usuario', style: estiloEncabezado)),
              DataColumn(label: Text('Editar', style: estiloEncabezado)),
            ],
            rows: registrosIncompletos.asMap().entries.map((entrada) {
              final vehiculo = entrada.value;
              final vin = vehiculo['vin']!;
              return DataRow(
                // Filas alternadas para leer mejor la tabla
                color: WidgetStateProperty.all(
                  entrada.key.isEven ? Colors.white : Colors.blue[50],
                ),
                cells: [
                  DataCell(
                    Text(
                      vin,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      vehiculo['usuario']!,
                      style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                    ),
                  ),
                  DataCell(
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue[100],
                        foregroundColor: Colors.blue[800],
                        disabledBackgroundColor: Colors.grey[200],
                      ),
                      icon: const Icon(Icons.edit, size: 20),
                      tooltip: 'Editar',
                      onPressed: _abriendoRegistro
                          ? null
                          : () => _abrirRegistro(vin),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _contenido() {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (mensajeSinRegistros != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.inbox_outlined, size: 56, color: Colors.white70),
            const SizedBox(height: 12),
            Text(
              mensajeSinRegistros!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return _tabla();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Registros Incompletos'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      endDrawer: const MenuLateral(),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue[900]!,
                  Colors.blue[700]!,
                  Colors.blue[400]!,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Selecciona por fecha',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _fechaController,
                      readOnly: true,
                      onTap: () => _seleccionarFecha(context),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[800],
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.blue[800],
                        ),
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.blue[800],
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: _contenido(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_abriendoRegistro)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.45),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
