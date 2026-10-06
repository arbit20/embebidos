import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicontrol/app.dart';
import 'package:medicontrol/core/theme/app_theme.dart';
import 'package:medicontrol/data/models/cita.dart';
import 'package:medicontrol/data/models/paciente.dart';
import 'package:medicontrol/data/repositories/local_auth_repository.dart';
import 'package:medicontrol/features/auth/auth_controller.dart';
import 'package:medicontrol/features/auth/login_screen.dart';
import 'package:medicontrol/features/clinica/clinica_controller.dart';
import 'package:provider/provider.dart';

import 'soporte/fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('el login exige correo y contraseña', (tester) async {
    final auth = AuthController(LocalAuthRepository(SesionMemoria()));
    await tester.pumpWidget(_login(auth));

    await tester.tap(find.byKey(const Key('boton-iniciar')));
    await tester.pump();

    expect(find.text('Ingresa el correo electrónico'), findsOneWidget);
    expect(auth.autenticado, isFalse);
  });

  testWidgets('rechaza una contraseña incorrecta', (tester) async {
    final auth = AuthController(LocalAuthRepository(SesionMemoria()));
    await tester.pumpWidget(_login(auth));

    await tester.enterText(
      find.byKey(const Key('campo-correo')),
      CredencialesDemo.correo,
    );
    await tester.enterText(
      find.byKey(const Key('campo-contrasena')),
      'incorrecta',
    );
    await tester.tap(find.byKey(const Key('boton-iniciar')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('error-login')), findsOneWidget);
    expect(auth.autenticado, isFalse);
  });

  testWidgets('el enlace de contraseña olvidada solo informa', (tester) async {
    final auth = AuthController(LocalAuthRepository(SesionMemoria()));
    await tester.pumpWidget(_login(auth));

    await tester.tap(find.text('¿Olvidaste tu contraseña?'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'La recuperación de contraseña estará disponible en una próxima versión.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('con la sesión demo entra al inicio y ve la próxima cita', (
    tester,
  ) async {
    final auth = AuthController(LocalAuthRepository(SesionMemoria()));
    await auth.cargarSesion();
    final clinica = ClinicaController(
      pacientes: PacientesMemoria([
        const Paciente(
          id: 1,
          nombre: 'Juan Pérez',
          ci: '1234567',
          telefono: '71234567',
          direccion: 'Calle Cala, Cochabamba',
        ),
      ]),
      citas: CitasMemoria([
        Cita(
          id: 1,
          pacienteId: 1,
          pacienteNombre: 'Juan Pérez',
          fechaHora: DateTime.now().add(const Duration(hours: 2)),
          motivo: 'Consulta general',
        ),
      ]),
    );
    await clinica.refrescar();

    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(MediControlApp(auth: auth, clinica: clinica));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('campo-correo')),
      CredencialesDemo.correo,
    );
    await tester.enterText(
      find.byKey(const Key('campo-contrasena')),
      CredencialesDemo.contrasena,
    );
    await tester.tap(find.byKey(const Key('boton-iniciar')));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Miguel'), findsOneWidget);
    expect(find.text('Próxima cita'), findsOneWidget);
    expect(find.text('Juan Pérez'), findsOneWidget);
    expect(find.text('Consulta general'), findsOneWidget);
  });
}

Widget _login(AuthController auth) {
  return ChangeNotifierProvider<AuthController>.value(
    value: auth,
    child: MaterialApp(theme: appTheme(), home: const LoginScreen()),
  );
}
