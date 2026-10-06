import '../models/paciente.dart';

class CiDuplicado implements Exception {
  const CiDuplicado();
}

/// Punto de enchufe para Firestore o una API REST.
abstract class PacienteRepository {
  Future<List<Paciente>> listar({String busqueda = ''});
  Future<Paciente?> obtener(int id);
  Future<bool> existeCi(String ci);
  Future<Paciente> crear(Paciente paciente);
}
