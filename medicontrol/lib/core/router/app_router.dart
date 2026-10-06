import 'package:go_router/go_router.dart';

import '../../features/agenda/agenda_screen.dart';
import '../../features/auth/auth_controller.dart';
import '../../features/auth/login_screen.dart';
import '../../features/citas/cita_form_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/mas/mas_screen.dart';
import '../../features/pacientes/paciente_form_screen.dart';
import '../../features/pacientes/pacientes_screen.dart';
import '../../features/perfil/perfil_screen.dart';
import '../../features/proximamente/proximamente_screen.dart';
import '../../widgets/app_shell.dart';

GoRouter crearRouter(AuthController auth) {
  return GoRouter(
    initialLocation: '/inicio',
    refreshListenable: auth,
    redirect: (context, state) {
      final enLogin = state.matchedLocation == '/login';
      if (!auth.autenticado) {
        return enLogin ? null : '/login';
      }
      if (enLogin) {
        return '/inicio';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inicio',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pacientes',
                builder: (context, state) => const PacientesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/citas',
                builder: (context, state) => const AgendaScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/mas',
                builder: (context, state) => const MasScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/paciente/nuevo',
        builder: (context, state) => const PacienteFormScreen(),
      ),
      GoRoute(
        path: '/paciente/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PerfilScreen(pacienteId: id);
        },
      ),
      GoRoute(
        path: '/cita/nueva',
        builder: (context, state) {
          final raw = state.uri.queryParameters['pacienteId'];
          return CitaFormScreen(
            pacienteId: raw == null ? null : int.tryParse(raw),
          );
        },
      ),
      GoRoute(
        path: '/historial',
        builder: (context, state) => const ProximamenteScreen(
          titulo: 'Historial médico',
          detalle:
              'El registro completo del historial clínico queda para una próxima versión.',
        ),
      ),
      GoRoute(
        path: '/tratamientos',
        builder: (context, state) => const ProximamenteScreen(
          titulo: 'Tratamientos',
          detalle:
              'La gestión de recetas y tratamientos queda para una próxima versión.',
        ),
      ),
    ],
  );
}
