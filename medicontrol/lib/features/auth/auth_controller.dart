import 'package:flutter/foundation.dart';

import '../../data/models/usuario.dart';
import '../../data/repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._repositorio);

  final AuthRepository _repositorio;

  Usuario? usuario;

  bool get autenticado => usuario != null;

  Future<void> cargarSesion() async {
    usuario = await _repositorio.sesionActual();
    notifyListeners();
  }

  Future<void> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    usuario = await _repositorio.iniciarSesion(
      correo: correo,
      contrasena: contrasena,
    );
    notifyListeners();
  }

  Future<void> cerrarSesion() async {
    await _repositorio.cerrarSesion();
    usuario = null;
    notifyListeners();
  }
}
