bool mismoDia(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String horaCorta(DateTime fecha) {
  final hora = fecha.hour.toString().padLeft(2, '0');
  final minuto = fecha.minute.toString().padLeft(2, '0');
  return '$hora:$minuto';
}

String fechaCorta(DateTime fecha) {
  final dia = fecha.day.toString().padLeft(2, '0');
  final mes = fecha.month.toString().padLeft(2, '0');
  return '$dia/$mes/${fecha.year}';
}

String fechaIso(DateTime fecha) => fecha.toIso8601String();

String fechaSolo(DateTime fecha) {
  final mes = fecha.month.toString().padLeft(2, '0');
  final dia = fecha.day.toString().padLeft(2, '0');
  return '${fecha.year}-$mes-$dia';
}

DateTime? parseFechaSolo(String? valor) {
  if (valor == null || valor.isEmpty) {
    return null;
  }
  final partes = valor.split('-');
  if (partes.length != 3) {
    return null;
  }
  return DateTime(
    int.parse(partes[0]),
    int.parse(partes[1]),
    int.parse(partes[2]),
  );
}

/// Etiqueta relativa usada en la tarjeta de próxima cita.
String cuando(DateTime fecha, DateTime ahora) {
  if (mismoDia(fecha, ahora)) {
    return 'Hoy · ${horaCorta(fecha)}';
  }
  final manana = DateTime(ahora.year, ahora.month, ahora.day + 1);
  if (mismoDia(fecha, manana)) {
    return 'Mañana · ${horaCorta(fecha)}';
  }
  return '${fechaCorta(fecha)} · ${horaCorta(fecha)}';
}

String iniciales(String nombre) {
  final partes = nombre
      .trim()
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (partes.isEmpty) {
    return '?';
  }
  if (partes.length == 1) {
    return partes.first[0].toUpperCase();
  }
  return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
}
