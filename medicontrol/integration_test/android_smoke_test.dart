import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:medicontrol/data/local/app_database.dart';
import 'package:medicontrol/data/local/session_store.dart';
import 'package:medicontrol/data/repositories/local_auth_repository.dart';
import 'package:medicontrol/features/auth/auth_controller.dart';
import 'package:medicontrol/main.dart' as app;
import 'package:medicontrol/widgets/paciente_tile.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Android: inicio, login, pacientes, agenda y sesión', (tester) async {
    Future<void> tap(Finder finder) async {
      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    Future<void> screenshot(String name) async {
      await tester.pumpAndSettle();
      await binding.takeScreenshot(name);
    }

    Finder field(String label) => find.byWidgetPredicate(
      (widget) => widget is TextField && widget.decoration?.labelText == label,
    );

    Finder patient(String name) => find.descendant(
      of: find.byType(PacienteTile),
      matching: find.text(name),
    );

    Future<void> login() async {
      await tester.enterText(
        find.byKey(const Key('campo-correo')),
        CredencialesDemo.correo,
      );
      await tester.enterText(
        find.byKey(const Key('campo-contrasena')),
        CredencialesDemo.contrasena,
      );
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tap(find.byKey(const Key('boton-iniciar')));
      expect(find.text('Hola, Miguel'), findsOneWidget);
    }

    await app.main();
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('boton-iniciar')), findsOneWidget);
    await screenshot('01-login');

    await tap(find.byKey(const Key('boton-iniciar')));
    expect(find.text('Ingresa el correo electrónico'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('campo-correo')),
      CredencialesDemo.correo,
    );
    await tester.enterText(
      find.byKey(const Key('campo-contrasena')),
      'incorrecta',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tap(find.byKey(const Key('boton-iniciar')));
    expect(find.byKey(const Key('error-login')), findsOneWidget);
    await tap(find.text('¿Olvidaste tu contraseña?'));
    expect(find.text('Recuperar contraseña'), findsOneWidget);
    await tap(find.text('Entendido'));
    expect(find.text('Recuperar contraseña'), findsNothing);

    await login();
    await screenshot('02-inicio');
    // Read real Android preferences through a fresh controller, without mocks.
    final savedSession = AuthController(LocalAuthRepository(PreferenciasSesion()));
    await savedSession.cargarSesion();
    expect(savedSession.autenticado, isTrue);
    savedSession.dispose();

    await tap(find.widgetWithText(NavigationDestination, 'Pacientes'));
    await tester.enterText(find.byKey(const Key('buscar-paciente')), 'Ana Torres');
    await tester.pumpAndSettle();
    expect(patient('Ana Torres'), findsOneWidget);
    await tap(patient('Ana Torres'));
    expect(find.text('Información del paciente'), findsOneWidget);
    await screenshot('03-perfil');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('buscar-paciente')), 'no-existe-ci');
    await tester.pumpAndSettle();
    expect(
      find.text('No hay pacientes que coincidan con la búsqueda.'),
      findsOneWidget,
    );
    await tester.enterText(find.byKey(const Key('buscar-paciente')), '');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tap(find.byTooltip('Registrar paciente'));
    await tap(find.text('Guardar paciente'));
    expect(find.text('Ingresa el nombre'), findsOneWidget);
    await tester.enterText(field('Nombre completo'), 'Paciente ficticio CI');
    await tester.enterText(field('CI'), '990000001');
    await tester.enterText(field('Teléfono'), '70000000');
    await tester.enterText(field('Dirección'), 'Dirección ficticia de prueba');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tap(find.text('Guardar paciente'));
    expect(find.text('Nuevo paciente'), findsNothing);
    await tester.enterText(find.byKey(const Key('buscar-paciente')), 'Paciente ficticio CI');
    await tester.pumpAndSettle();
    expect(patient('Paciente ficticio CI'), findsOneWidget);
    final database = await AppDatabase.abrir();
    final rows = await database.db.query(
      'pacientes',
      where: 'ci = ?',
      whereArgs: ['990000001'],
    );
    expect(rows, hasLength(1));
    expect(rows.single['nombre'], 'Paciente ficticio CI');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await screenshot('04-paciente-creado');

    await tap(find.widgetWithText(NavigationDestination, 'Citas'));
    expect(find.text('Agenda'), findsOneWidget);
    await screenshot('05-agenda');
    final before = await database.db.query('citas');
    await tap(find.text('Nueva cita'));
    await tap(find.text('Guardar cita'));
    expect(find.text('Selecciona la fecha y la hora'), findsOneWidget);
    await tap(find.text('Cancelar'));
    expect(find.text('Agenda'), findsOneWidget);
    expect(await database.db.query('citas'), hasLength(before.length));
    // Re-enter and use Back to cover interrupted/repeated navigation.
    await tap(find.text('Nueva cita'));
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Agenda'), findsOneWidget);

    await tap(find.widgetWithText(NavigationDestination, 'Más'));
    await tap(find.text('Cerrar sesión'));
    await tap(find.text('Cancelar'));
    expect(find.text(CredencialesDemo.correo), findsOneWidget);
    await tap(find.text('Cerrar sesión'));
    await tap(find.text('Salir'));
    expect(find.byKey(const Key('boton-iniciar')), findsOneWidget);
    final clearedSession = AuthController(LocalAuthRepository(PreferenciasSesion()));
    await clearedSession.cargarSesion();
    expect(clearedSession.autenticado, isFalse);
    clearedSession.dispose();
    await login();
    await screenshot('06-reinicio-sesion');
    expect(tester.takeException(), isNull);
  });
}
