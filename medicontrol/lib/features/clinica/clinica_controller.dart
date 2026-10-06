import 'package:flutter/foundation.dart';

import '../../core/consultas.dart';
import '../../data/models/cita.dart';
import '../../data/models/paciente.dart';
import '../../data/repositories/cita_repository.dart';
import '../../data/repositories/paciente_repository.dart';

class ClinicaController extends ChangeNotifier {
  ClinicaController({required this.pacientes, required this.citas});

  final PacienteRepository pacientes;
  final CitaRepository citas;

  /// Catálogo completo, independiente de la búsqueda de la lista.
  List<Paciente> catalogo = [];
  List<Paciente> lista = [];
  List<Cita> agenda = [];
  bool cargando = false;
  String? error;
  String _busqueda = '';

  String get busqueda => _busqueda;

  Cita? get proxima => proximaCita(agenda, DateTime.now());

  List<Cita> citasDelDia(DateTime dia) => citasEnDia(agenda, dia);

  List<Cita> historialDe(int pacienteId) {
    return historialPaciente(agenda, pacienteId, DateTime.now());
  }

  DateTime? ultimaConsultaDe(int pacienteId) {
    final historial = historialDe(pacienteId);
    if (historial.isEmpty) {
      return null;
    }
    return historial.first.fechaHora;
  }

  Future<void> refrescar() async {
    cargando = true;
    notifyListeners();
    try {
      catalogo = await pacientes.listar();
      lista = _busqueda.isEmpty
          ? catalogo
          : await pacientes.listar(busqueda: _busqueda);
      agenda = await citas.listar();
      error = null;
    } catch (_) {
      error = 'No se pudieron cargar los datos locales';
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> buscar(String texto) async {
    _busqueda = texto.trim();
    try {
      lista = _busqueda.isEmpty
          ? catalogo
          : await pacientes.listar(busqueda: _busqueda);
      error = null;
    } catch (_) {
      error = 'No se pudo buscar pacientes';
    }
    notifyListeners();
  }

  Future<Paciente?> obtenerPaciente(int id) => pacientes.obtener(id);

  Future<void> agregarPaciente(Paciente paciente) async {
    await pacientes.crear(paciente);
    await refrescar();
  }

  Future<void> agregarCita(Cita cita) async {
    await citas.crear(cita);
    await refrescar();
  }
}
