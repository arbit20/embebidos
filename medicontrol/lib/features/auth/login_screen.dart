import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/validators.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/local_auth_repository.dart';
import 'auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correo = TextEditingController();
  final _contrasena = TextEditingController();
  bool _ocultar = true;
  bool _enviando = false;
  String? _error;

  @override
  void dispose() {
    _correo.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _enviando = true;
      _error = null;
    });
    try {
      await context.read<AuthController>().iniciarSesion(
        correo: _correo.text,
        contrasena: _contrasena.text,
      );
    } on CredencialesInvalidas {
      if (mounted) {
        setState(() => _error = 'Correo o contraseña incorrectos');
      }
    } finally {
      if (mounted) {
        setState(() => _enviando = false);
      }
    }
  }

  void _olvidoContrasena() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Recuperar contraseña'),
          content: const Text(
            'La recuperación de contraseña estará disponible en una próxima versión.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFE7F3FF)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 36),
                          const Icon(
                            Icons.monitor_heart,
                            size: 78,
                            color: AppColors.azul,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'MediControl',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppColors.azul,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Gestión de pacientes y citas médicas',
                            style: TextStyle(color: AppColors.textoSuave),
                          ),
                          const SizedBox(height: 36),
                          TextFormField(
                            key: const Key('campo-correo'),
                            controller: _correo,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Correo electrónico',
                              hintText: 'usuario@gmail.com',
                              prefixIcon: Icon(Icons.mail_outline),
                            ),
                            validator: validarCorreo,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            key: const Key('campo-contrasena'),
                            controller: _contrasena,
                            obscureText: _ocultar,
                            autofillHints: const [AutofillHints.password],
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _entrar(),
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                tooltip: _ocultar
                                    ? 'Mostrar contraseña'
                                    : 'Ocultar contraseña',
                                onPressed: () =>
                                    setState(() => _ocultar = !_ocultar),
                                icon: Icon(
                                  _ocultar
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                            validator: validarContrasena,
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _error!,
                              key: const Key('error-login'),
                              style: const TextStyle(color: Color(0xFFB3261E)),
                            ),
                          ],
                          const SizedBox(height: 22),
                          FilledButton(
                            key: const Key('boton-iniciar'),
                            onPressed: _enviando ? null : _entrar,
                            child: _enviando
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Iniciar sesión'),
                          ),
                          TextButton(
                            onPressed: _olvidoContrasena,
                            child: const Text('¿Olvidaste tu contraseña?'),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Demostración: ${CredencialesDemo.correo}\n${CredencialesDemo.contrasena}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textoSuave,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 28, top: 24),
                            child: Text(
                              'Cuidamos tu salud',
                              style: TextStyle(
                                color: AppColors.azul,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
