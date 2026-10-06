import '../local/app_database.dart';
import '../models/cita.dart';
import 'cita_repository.dart';

class LocalCitaRepository implements CitaRepository {
  LocalCitaRepository(this._base);

  final AppDatabase _base;

  static const _consulta = '''
    SELECT c.id, c.paciente_id, c.fecha_hora, c.motivo, c.notas,
           p.nombre AS paciente_nombre
    FROM citas c
    INNER JOIN pacientes p ON p.id = c.paciente_id
  ''';

  @override
  Future<List<Cita>> listar() async {
    final filas = await _base.db.rawQuery(
      '$_consulta ORDER BY c.fecha_hora ASC',
    );
    return filas.map(Cita.fromMap).toList();
  }

  @override
  Future<Cita> crear(Cita cita) async {
    final id = await _base.db.insert('citas', cita.toInsertMap());
    final filas = await _base.db.rawQuery('$_consulta WHERE c.id = ?', [id]);
    return Cita.fromMap(filas.first);
  }
}
