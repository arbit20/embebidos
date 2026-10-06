import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'data/local/app_database.dart';
import 'data/local/session_store.dart';
import 'data/repositories/local_auth_repository.dart';
import 'data/repositories/local_cita_repository.dart';
import 'data/repositories/local_paciente_repository.dart';
import 'features/auth/auth_controller.dart';
import 'features/clinica/clinica_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES');

  final base = await AppDatabase.abrir();
  final auth = AuthController(LocalAuthRepository(PreferenciasSesion()));
  await auth.cargarSesion();

  final clinica = ClinicaController(
    pacientes: LocalPacienteRepository(base),
    citas: LocalCitaRepository(base),
  );
  await clinica.refrescar();

  runApp(MediControlApp(auth: auth, clinica: clinica));
}
