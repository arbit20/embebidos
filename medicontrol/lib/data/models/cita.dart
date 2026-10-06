import '../../core/format/fechas.dart';

class Cita {
  const Cita({
    this.id,
    required this.pacienteId,
    required this.pacienteNombre,
    required this.fechaHora,
    required this.motivo,
    this.notas = '',
  });

  final int? id;
  final int pacienteId;
  final String pacienteNombre;
  final DateTime fechaHora;
  final String motivo;
  final String notas;

  Map<String, Object?> toInsertMap() {
    return {
      'paciente_id': pacienteId,
      'fecha_hora': fechaIso(fechaHora),
      'motivo': motivo,
      'notas': notas.trim(),
    };
  }

  factory Cita.fromMap(Map<String, Object?> map) {
    return Cita(
      id: map['id'] as int,
      pacienteId: map['paciente_id'] as int,
      pacienteNombre: (map['paciente_nombre'] as String?) ?? '',
      fechaHora: DateTime.parse(map['fecha_hora'] as String),
      motivo: map['motivo'] as String,
      notas: (map['notas'] as String?) ?? '',
    );
  }
}
