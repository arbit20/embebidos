import '../../core/format/fechas.dart';

class Paciente {
  const Paciente({
    this.id,
    required this.nombre,
    required this.ci,
    required this.telefono,
    this.fechaNacimiento,
    required this.direccion,
    this.activo = true,
  });

  final int? id;
  final String nombre;
  final String ci;
  final String telefono;
  final DateTime? fechaNacimiento;
  final String direccion;
  final bool activo;

  int? edadEn(DateTime hoy) {
    final nacimiento = fechaNacimiento;
    if (nacimiento == null) {
      return null;
    }
    var edad = hoy.year - nacimiento.year;
    final cumple = DateTime(hoy.year, nacimiento.month, nacimiento.day);
    if (hoy.isBefore(cumple)) {
      edad -= 1;
    }
    return edad;
  }

  Map<String, Object?> toInsertMap() {
    return {
      'nombre': nombre.trim(),
      'ci': ci.trim(),
      'telefono': telefono.trim(),
      'fecha_nacimiento': fechaNacimiento == null
          ? null
          : fechaSolo(fechaNacimiento!),
      'direccion': direccion.trim(),
      'activo': activo ? 1 : 0,
    };
  }

  factory Paciente.fromMap(Map<String, Object?> map) {
    return Paciente(
      id: map['id'] as int,
      nombre: map['nombre'] as String,
      ci: map['ci'] as String,
      telefono: map['telefono'] as String,
      fechaNacimiento: parseFechaSolo(map['fecha_nacimiento'] as String?),
      direccion: map['direccion'] as String,
      activo: (map['activo'] as int) == 1,
    );
  }
}
