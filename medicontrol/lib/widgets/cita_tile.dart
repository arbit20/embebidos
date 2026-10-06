import 'package:flutter/material.dart';

import '../core/format/fechas.dart';
import '../core/theme/app_theme.dart';
import '../data/models/cita.dart';

class CitaTile extends StatelessWidget {
  const CitaTile({super.key, required this.cita});

  final Cita cita;

  @override
  Widget build(BuildContext context) {
    return TarjetaCita(
      hora: horaCorta(cita.fechaHora),
      titulo: cita.pacienteNombre,
      detalle: cita.motivo,
    );
  }
}

class TarjetaCita extends StatelessWidget {
  const TarjetaCita({
    super.key,
    required this.hora,
    required this.titulo,
    required this.detalle,
  });

  final String hora;
  final String titulo;
  final String detalle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              hora,
              style: const TextStyle(
                color: AppColors.azul,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borde),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      detalle,
                      style: const TextStyle(color: AppColors.textoSuave),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
