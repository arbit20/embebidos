import '../models/usuario.dart';

class CredencialesInvalidas implements Exception {
  const CredencialesInvalidas();
}

/// Punto de enchufe para un backend futuro (Firebase Auth o API).
abstract class AuthRepository {
  Future<Usuario?> sesionActual();
  Future<Usuario> iniciarSesion({
    required String correo,
    required String contrasena,
  });
  Future<void> cerrarSesion();
}
