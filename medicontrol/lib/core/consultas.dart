import '../data/models/cita.dart';
import 'format/fechas.dart';

/// Primera cita que todavía no empieza. El repositorio remoto futuro
/// puede reemplazar el origen de la lista sin cambiar esta regla.
Cita? proximaCita(List<Cita> citas, DateTime ahora) {
  Cita? proxima;
  for (final cita in citas) {
    if (cita.fechaHora.isBefore(ahora)) {
      continue;
    }
    if (proxima == null || cita.fechaHora.isBefore(proxima.fechaHora)) {
      proxima = cita;
    }
  }
  return proxima;
}

List<Cita> citasEnDia(List<Cita> citas, DateTime dia) {
  final delDia = citas.where((cita) => mismoDia(cita.fechaHora, dia)).toList();
  delDia.sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
  return delDia;
}

/// Consultas ya realizadas, de la más reciente a la más antigua.
List<Cita> historialPaciente(List<Cita> citas, int pacienteId, DateTime ahora) {
  final pasadas = citas
      .where(
        (cita) =>
            cita.pacienteId == pacienteId && cita.fechaHora.isBefore(ahora),
      )
      .toList();
  pasadas.sort((a, b) => b.fechaHora.compareTo(a.fechaHora));
  return pasadas;
}
