final _correo = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
final _digitos = RegExp(r'^\d+$');

String? validarCorreo(String? valor) {
  final texto = valor?.trim() ?? '';
  if (texto.isEmpty) {
    return 'Ingresa el correo electrónico';
  }
  if (!_correo.hasMatch(texto)) {
    return 'El correo no tiene un formato válido';
  }
  return null;
}

String? validarContrasena(String? valor) {
  if (valor == null || valor.isEmpty) {
    return 'Ingresa la contraseña';
  }
  if (valor.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres';
  }
  return null;
}

String? validarRequerido(String? valor, String campo) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Ingresa $campo';
  }
  return null;
}

String? validarCi(String? valor) {
  final texto = valor?.trim() ?? '';
  if (texto.isEmpty) {
    return 'Ingresa el CI';
  }
  if (!_digitos.hasMatch(texto) || texto.length < 5 || texto.length > 10) {
    return 'El CI debe tener entre 5 y 10 dígitos';
  }
  return null;
}

String? validarTelefono(String? valor) {
  final texto = valor?.trim() ?? '';
  if (texto.isEmpty) {
    return 'Ingresa el teléfono';
  }
  if (!_digitos.hasMatch(texto) || texto.length < 7 || texto.length > 12) {
    return 'El teléfono debe tener entre 7 y 12 dígitos';
  }
  return null;
}
