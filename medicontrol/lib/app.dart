import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_controller.dart';
import 'features/clinica/clinica_controller.dart';

class MediControlApp extends StatefulWidget {
  const MediControlApp({
    super.key,
    required this.auth,
    required this.clinica,
    this.router,
  });

  final AuthController auth;
  final ClinicaController clinica;

  /// Permite inyectar el router en pruebas. Si es null, se crea uno propio.
  final GoRouter? router;

  @override
  State<MediControlApp> createState() => _MediControlAppState();
}

class _MediControlAppState extends State<MediControlApp> {
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    _router = widget.router ?? crearRouter(widget.auth);
  }

  @override
  void dispose() {
    if (widget.router == null) {
      _router?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>.value(value: widget.auth),
        ChangeNotifierProvider<ClinicaController>.value(value: widget.clinica),
      ],
      child: MaterialApp.router(
        title: 'MediControl',
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        locale: const Locale('es', 'ES'),
        supportedLocales: const [Locale('es', 'ES'), Locale('es')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: _router,
      ),
    );
  }
}
