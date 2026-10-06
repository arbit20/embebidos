import '../models/cita.dart';
import '../models/paciente.dart';

/// Datos de demostración alineados con la figura de MediControl.
/// Las citas se calculan respecto de [ahora] para que la agenda y la
/// próxima cita tengan contenido el día en que se instala la app.
class Semilla {
  const Semilla({required this.pacientes, required this.citas});

  final List<Paciente> pacientes;
  final List<Cita> citas;
}

Semilla crearSemilla(DateTime ahora) {
  final pacientes = <Paciente>[
    Paciente(
      id: 1,
      nombre: 'Juan Pérez',
      ci: '1234567',
      telefono: '71234567',
      fechaNacimiento: DateTime(1994, 3, 12),
      direccion: 'Calle Cala, Cochabamba',
    ),
    Paciente(
      id: 2,
      nombre: 'María López',
      ci: '7654321',
      telefono: '72345678',
      fechaNacimiento: DateTime(1988, 6, 2),
      direccion: 'Av. América 120, Cochabamba',
    ),
    Paciente(
      id: 3,
      nombre: 'Carlos Andrade',
      ci: '4567890',
      telefono: '73456789',
      fechaNacimiento: DateTime(1979, 11, 20),
      direccion: 'Calle Sucre 45, Cochabamba',
    ),
    Paciente(
      id: 4,
      nombre: 'Ana Torres',
      ci: '9876543',
      telefono: '74567890',
      fechaNacimiento: DateTime(1996, 1, 15),
      direccion: 'Av. Blanco Galindo 800, Cochabamba',
    ),
    Paciente(
      id: 5,
      nombre: 'Luis Fernández',
      ci: '1122334',
      telefono: '75678901',
      fechaNacimiento: DateTime(1985, 9, 9),
      direccion: 'Calle Colombia 22, Cochabamba',
    ),
  ];

  DateTime dia(int offset, int hora, int minuto) {
    return DateTime(ahora.year, ahora.month, ahora.day + offset, hora, minuto);
  }

  final citas = <Cita>[
    Cita(
      pacienteId: 1,
      pacienteNombre: 'Juan Pérez',
      fechaHora: dia(0, 9, 0),
      motivo: 'Consulta general',
      notas: 'Control de rutina.',
    ),
    Cita(
      pacienteId: 2,
      pacienteNombre: 'María López',
      fechaHora: dia(0, 11, 30),
      motivo: 'Control',
    ),
    Cita(
      pacienteId: 3,
      pacienteNombre: 'Carlos Andrade',
      fechaHora: dia(0, 16, 30),
      motivo: 'Seguimiento',
      notas: 'Paciente con dolor de cabeza.',
    ),
    Cita(
      pacienteId: 4,
      pacienteNombre: 'Ana Torres',
      fechaHora: dia(1, 10, 30),
      motivo: 'Consulta general',
    ),
    Cita(
      pacienteId: 5,
      pacienteNombre: 'Luis Fernández',
      fechaHora: dia(3, 15, 0),
      motivo: 'Control',
    ),
    Cita(
      pacienteId: 1,
      pacienteNombre: 'Juan Pérez',
      fechaHora: dia(-14, 8, 30),
      motivo: 'Consulta general',
    ),
    Cita(
      pacienteId: 1,
      pacienteNombre: 'Juan Pérez',
      fechaHora: dia(-30, 15, 0),
      motivo: 'Control de presión',
    ),
    Cita(
      pacienteId: 2,
      pacienteNombre: 'María López',
      fechaHora: dia(-6, 9, 30),
      motivo: 'Control',
    ),
    Cita(
      pacienteId: 3,
      pacienteNombre: 'Carlos Andrade',
      fechaHora: dia(-10, 11, 0),
      motivo: 'Seguimiento',
    ),
    Cita(
      pacienteId: 4,
      pacienteNombre: 'Ana Torres',
      fechaHora: dia(-20, 16, 0),
      motivo: 'Consulta general',
    ),
    Cita(
      pacienteId: 5,
      pacienteNombre: 'Luis Fernández',
      fechaHora: dia(-25, 10, 0),
      motivo: 'Consulta general',
    ),
  ];

  return Semilla(pacientes: pacientes, citas: citas);
}

/// Motivos que el formulario de nueva cita ofrece en este avance.
const motivosDeCita = <String>[
  'Consulta general',
  'Control',
  'Seguimiento',
  'Control de presión',
];
