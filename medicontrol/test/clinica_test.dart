import 'package:flutter_test/flutter_test.dart';
import 'package:medicontrol/data/models/cita.dart';
import 'package:medicontrol/data/models/paciente.dart';
import 'package:medicontrol/data/repositories/auth_repository.dart';
import 'package:medicontrol/data/repositories/local_auth_repository.dart';
import 'package:medicontrol/features/auth/auth_controller.dart';
import 'package:medicontrol/features/clinica/clinica_controller.dart';

import 'soporte/fakes.dart';

Paciente _juan() {
  return const Paciente(
    id: 1,
    nombre: 'Juan Pérez',
    ci: '1234567',
    telefono: '71234567',
    direccion: 'Calle Cala, Cochabamba',
  );
}

void main() {
  test('la sesión se guarda y vuelve a aparecer al iniciar', () async {
    final sesion = SesionMemoria();
    final auth = AuthController(LocalAuthRepository(sesion));

    await expectLater(
      auth.iniciarSesion(correo: 'otro@correo.com', contrasena: 'demo1234'),
      throwsA(isA<CredencialesInvalidas>()),
    );

    await auth.iniciarSesion(
      correo: '  Miguel@ClinicaDemo.com ',
      contrasena: CredencialesDemo.contrasena,
    );
    expect(sesion.usuario?.nombre, 'Miguel');

    final reinicio = AuthController(LocalAuthRepository(sesion));
    await reinicio.cargarSesion();
    expect(reinicio.autenticado, isTrue);
    expect(reinicio.usuario?.correo, CredencialesDemo.correo);

    await reinicio.cerrarSesion();
    expect(sesion.usuario, isNull);
  });

  test(
    'buscar no vacía el catálogo y una cita nueva queda como próxima',
    () async {
      final clinica = ClinicaController(
        pacientes: PacientesMemoria([_juan()]),
        citas: CitasMemoria([
          Cita(
            id: 1,
            pacienteId: 1,
            pacienteNombre: 'Juan Pérez',
            fechaHora: DateTime.now().subtract(const Duration(days: 2)),
            motivo: 'Consulta general',
          ),
        ]),
      );
      await clinica.refrescar();

      await clinica.buscar('no-existe');
      expect(clinica.lista, isEmpty);
      expect(clinica.catalogo, hasLength(1));

      await clinica.agregarCita(
        Cita(
          pacienteId: 1,
          pacienteNombre: 'Juan Pérez',
          fechaHora: DateTime.now().add(const Duration(hours: 3)),
          motivo: 'Control',
        ),
      );

      expect(clinica.proxima?.motivo, 'Control');
      expect(clinica.historialDe(1), hasLength(1));
    },
  );
}
