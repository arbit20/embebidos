/// Texto fijo de este avance. No hay tabla de tratamientos todavía.
String tratamientoFijo(int pacienteId) {
  const textos = <String>[
    'Amoxicilina 500 mg\nCada 8 horas · 7 días',
    'Losartán 50 mg\nCada 24 horas · 30 días',
    'Ibuprofeno 400 mg\nCada 8 horas · 5 días',
    'Omeprazol 20 mg\nEn ayunas · 14 días',
    'Paracetamol 500 mg\nCada 8 horas · 3 días',
  ];
  final indice = (pacienteId - 1).abs() % textos.length;
  return textos[indice];
}
