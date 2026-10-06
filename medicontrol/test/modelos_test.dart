import 'package:flutter_test/flutter_test.dart';
import 'package:medicontrol/core/consultas.dart';
import 'package:medicontrol/core/format/fechas.dart';
import 'package:medicontrol/data/local/semilla.dart';
import 'package:medicontrol/data/models/cita.dart';
import 'package:medicontrol/data/models/paciente.dart';

void main() {
  test('Juan Pérez tiene 32 años el 5 de octubre de 2026', () {
    final paciente = Paciente.fromMap({
      'id': 1,
      'nombre': 'Juan Pérez',
      'ci': '1234567',
      'telefono': '71234567',
      'fecha_nacimiento': '1994-03-12',
      'direccion': 'Calle Cala, Cochabamba',
      'activo': 1,
    });

    expect(paciente.edadEn(DateTime(2026, 10, 5)), 32);
    expect(paciente.edadEn(DateTime(2026, 3, 11)), 31);
    expect(paciente.toInsertMap()['fecha_nacimiento'], '1994-03-12');
    expect(paciente.toInsertMap().containsKey('id'), isFalse);
  });

  test('una cita conserva fecha, motivo y paciente', () {
    final cita = Cita.fromMap({
      'id': 4,
      'paciente_id': 2,
      'paciente_nombre': 'María López',
      'fecha_hora': '2026-10-05T11:30:00.000',
      'motivo': 'Control',
      'notas': '',
    });

    expect(cita.pacienteNombre, 'María López');
    expect(cita.toInsertMap()['paciente_id'], 2);
    expect(cita.toInsertMap()['motivo'], 'Control');
    expect(horaCorta(cita.fechaHora), '11:30');
  });

  test('la semilla trae los cinco pacientes y citas de hoy', () {
    final ahora = DateTime(2026, 10, 5, 8);
    final semilla = crearSemilla(ahora);

    expect(semilla.pacientes.map((p) => p.nombre), [
      'Juan Pérez',
      'María López',
      'Carlos Andrade',
      'Ana Torres',
      'Luis Fernández',
    ]);
    expect(citasEnDia(semilla.citas, ahora), hasLength(3));
    expect(historialPaciente(semilla.citas, 1, ahora), isNotEmpty);
  });

  test('la próxima cita es la primera que aún no empieza', () {
    final ahora = DateTime(2026, 10, 5, 12);
    final citas = [
      Cita(
        id: 1,
        pacienteId: 1,
        pacienteNombre: 'Juan Pérez',
        fechaHora: DateTime(2026, 10, 5, 9),
        motivo: 'Consulta general',
      ),
      Cita(
        id: 2,
        pacienteId: 2,
        pacienteNombre: 'María López',
        fechaHora: DateTime(2026, 10, 5, 16, 30),
        motivo: 'Control',
      ),
    ];

    expect(proximaCita(citas, ahora)?.id, 2);
    expect(cuando(citas[1].fechaHora, ahora), 'Hoy · 16:30');
    expect(cuando(DateTime(2026, 10, 6, 9), ahora), 'Mañana · 09:00');
  });
}
