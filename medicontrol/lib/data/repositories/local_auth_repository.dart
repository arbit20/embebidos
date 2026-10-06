import '../local/session_store.dart';
import '../models/usuario.dart';
import 'auth_repository.dart';

/// Usuario de demostración. La contraseña va en texto plano a propósito:
/// el hash y el registro de usuarios quedan fuera de este avance.
abstract final class CredencialesDemo {
  static const id = 'miguel';
  static const nombre = 'Miguel';
  static const correo = 'miguel@clinicademo.com';
  static const contrasena = 'demo1234';
}

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._sesion);

  final SessionStore _sesion;

  @override
  Future<Usuario?> sesionActual() => _sesion.leer();

  @override
  Future<Usuario> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    final correoNormalizado = correo.trim().toLowerCase();
    final coincide =
        correoNormalizado == CredencialesDemo.correo &&
        contrasena == CredencialesDemo.contrasena;
    if (!coincide) {
      throw const CredencialesInvalidas();
    }
    const usuario = Usuario(
      id: CredencialesDemo.id,
      nombre: CredencialesDemo.nombre,
      correo: CredencialesDemo.correo,
    );
    await _sesion.guardar(usuario);
    return usuario;
  }

  @override
  Future<void> cerrarSesion() => _sesion.borrar();
}
