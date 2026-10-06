import 'package:medicontrol/data/local/session_store.dart';
import 'package:medicontrol/data/models/cita.dart';
import 'package:medicontrol/data/models/paciente.dart';
import 'package:medicontrol/data/models/usuario.dart';
import 'package:medicontrol/data/repositories/cita_repository.dart';
import 'package:medicontrol/data/repositories/paciente_repository.dart';

class SesionMemoria implements SessionStore {
  Usuario? usuario;

  @override
  Future<void> borrar() async {
    usuario = null;
  }

  @override
  Future<void> guardar(Usuario usuario) async {
    this.usuario = usuario;
  }

  @override
  Future<Usuario?> leer() async => usuario;
}

class PacientesMemoria implements PacienteRepository {
  PacientesMemoria(List<Paciente> iniciales) : _datos = [...iniciales];

  final List<Paciente> _datos;

  @override
  Future<Paciente> crear(Paciente paciente) async {
    if (await existeCi(paciente.ci)) {
      throw const CiDuplicado();
    }
    final id =
        _datos.fold<int>(
          0,
          (max, actual) => (actual.id ?? 0) > max ? actual.id! : max,
        ) +
        1;
    final creado = Paciente(
      id: id,
      nombre: paciente.nombre.trim(),
      ci: paciente.ci.trim(),
      telefono: paciente.telefono.trim(),
      fechaNacimiento: paciente.fechaNacimiento,
      direccion: paciente.direccion.trim(),
    );
    _datos.add(creado);
    return creado;
  }

  @override
  Future<bool> existeCi(String ci) async {
    final buscado = ci.trim();
    return _datos.any((paciente) => paciente.ci == buscado);
  }

  @override
  Future<List<Paciente>> listar({String busqueda = ''}) async {
    final texto = busqueda.trim().toLowerCase();
    if (texto.isEmpty) {
      return [..._datos];
    }
    return _datos
        .where(
          (paciente) =>
              paciente.nombre.toLowerCase().contains(texto) ||
              paciente.ci.contains(texto),
        )
        .toList();
  }

  @override
  Future<Paciente?> obtener(int id) async {
    for (final paciente in _datos) {
      if (paciente.id == id) {
        return paciente;
      }
    }
    return null;
  }
}

class CitasMemoria implements CitaRepository {
  CitasMemoria(List<Cita> iniciales) : _datos = [...iniciales];

  final List<Cita> _datos;

  @override
  Future<Cita> crear(Cita cita) async {
    final id =
        _datos.fold<int>(
          0,
          (max, actual) => (actual.id ?? 0) > max ? actual.id! : max,
        ) +
        1;
    final creada = Cita(
      id: id,
      pacienteId: cita.pacienteId,
      pacienteNombre: cita.pacienteNombre,
      fechaHora: cita.fechaHora,
      motivo: cita.motivo,
      notas: cita.notas,
    );
    _datos.add(creada);
    return creada;
  }

  @override
  Future<List<Cita>> listar() async => [..._datos];
}
