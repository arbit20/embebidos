import '../models/cita.dart';

/// Punto de enchufe para sincronizar la agenda más adelante.
abstract class CitaRepository {
  Future<List<Cita>> listar();
  Future<Cita> crear(Cita cita);
}
