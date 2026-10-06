import '../local/app_database.dart';
import '../models/paciente.dart';
import 'paciente_repository.dart';

class LocalPacienteRepository implements PacienteRepository {
  LocalPacienteRepository(this._base);

  final AppDatabase _base;

  @override
  Future<List<Paciente>> listar({String busqueda = ''}) async {
    final texto = busqueda.trim();
    final filas = texto.isEmpty
        ? await _base.db.query('pacientes', orderBy: 'nombre COLLATE NOCASE')
        : await _base.db.query(
            'pacientes',
            where: "nombre LIKE ? ESCAPE '\\' OR ci LIKE ? ESCAPE '\\'",
            whereArgs: [_like(texto), _like(texto)],
            orderBy: 'nombre COLLATE NOCASE',
          );
    return filas.map(Paciente.fromMap).toList();
  }

  @override
  Future<Paciente?> obtener(int id) async {
    final filas = await _base.db.query(
      'pacientes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (filas.isEmpty) {
      return null;
    }
    return Paciente.fromMap(filas.first);
  }

  @override
  Future<bool> existeCi(String ci) async {
    final filas = await _base.db.query(
      'pacientes',
      columns: ['id'],
      where: 'ci = ?',
      whereArgs: [ci.trim()],
      limit: 1,
    );
    return filas.isNotEmpty;
  }

  @override
  Future<Paciente> crear(Paciente paciente) async {
    if (await existeCi(paciente.ci)) {
      throw const CiDuplicado();
    }
    final id = await _base.db.insert('pacientes', paciente.toInsertMap());
    return Paciente(
      id: id,
      nombre: paciente.nombre.trim(),
      ci: paciente.ci.trim(),
      telefono: paciente.telefono.trim(),
      fechaNacimiento: paciente.fechaNacimiento,
      direccion: paciente.direccion.trim(),
      activo: paciente.activo,
    );
  }
}

String _like(String texto) {
  final limpio = texto
      .replaceAll(r'\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_');
  return '%$limpio%';
}
