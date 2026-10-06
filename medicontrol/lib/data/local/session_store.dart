import 'package:shared_preferences/shared_preferences.dart';

import '../models/usuario.dart';

/// Persistencia de la sesión. Al abrir la app se leen estas claves:
/// si existen, el usuario entra directo al inicio (mismo patrón que la
/// evaluación de SharedPreferences del hito 3).
abstract class SessionStore {
  Future<Usuario?> leer();
  Future<void> guardar(Usuario usuario);
  Future<void> borrar();
}

class PreferenciasSesion implements SessionStore {
  static const _id = 'sesion_id';
  static const _nombre = 'sesion_nombre';
  static const _correo = 'sesion_correo';

  @override
  Future<Usuario?> leer() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_id);
    final nombre = prefs.getString(_nombre);
    final correo = prefs.getString(_correo);
    if (id == null || nombre == null || correo == null || nombre.isEmpty) {
      return null;
    }
    return Usuario(id: id, nombre: nombre, correo: correo);
  }

  @override
  Future<void> guardar(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_id, usuario.id);
    await prefs.setString(_nombre, usuario.nombre);
    await prefs.setString(_correo, usuario.correo);
  }

  @override
  Future<void> borrar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_id);
    await prefs.remove(_nombre);
    await prefs.remove(_correo);
  }
}
