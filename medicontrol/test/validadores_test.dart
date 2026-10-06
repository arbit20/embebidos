import 'package:flutter_test/flutter_test.dart';
import 'package:medicontrol/core/validators.dart';

void main() {
  test('el correo exige formato válido', () {
    expect(validarCorreo(''), 'Ingresa el correo electrónico');
    expect(validarCorreo('miguel'), isNotNull);
    expect(validarCorreo('miguel@clinicademo.com'), isNull);
  });

  test('la contraseña exige al menos 6 caracteres', () {
    expect(validarContrasena(''), 'Ingresa la contraseña');
    expect(validarContrasena('12345'), isNotNull);
    expect(validarContrasena('demo1234'), isNull);
  });

  test('el CI y el teléfono solo aceptan dígitos', () {
    expect(validarCi('abc'), isNotNull);
    expect(validarCi('1234567'), isNull);
    expect(validarTelefono('123'), isNotNull);
    expect(validarTelefono('71234567'), isNull);
  });
}
