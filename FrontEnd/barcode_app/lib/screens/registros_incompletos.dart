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

    if (result['error'] == true) {
      // Manejar error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['mensaje'])));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registros Incompletos'),

        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      endDrawer: const MenuLateral(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            children: [
              const Text(
                'Selecciona por fecha:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              TextField(
                controller: _fechaController,
                readOnly: true,
                onTap: () => _seleccionarFecha(context),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            Colors.blue[800],
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(
                                'VIN',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Usuario',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Editar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                          rows: registrosIncompletos.map((vehiculo) {
                            return DataRow(
                              cells: [
                                DataCell(Text(vehiculo['vin']!)),
                                DataCell(Text(vehiculo['usuario']!)),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () async {
                                      final String vinSeleccionado =
                                          vehiculo['vin']!;

                                      // 🔄 Llamada al API
                                      final response =
                                          await AuthService.obtenerEstadoInstalacion(
                                            vinSeleccionado,
                                          );

                                      if (response['error'] == true) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              response['mensaje'] ??
                                                  'Error al obtener datos',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      // 🚀 Navegación con JSON completo
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MostrarDatosVehiculo(
                                            vehiculoData:
                                                response, // 🔥 AQUÍ VA TODO
                                            vieneRegistrosIncompletos: true,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (mensajeSinRegistros != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    mensajeSinRegistros!,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
