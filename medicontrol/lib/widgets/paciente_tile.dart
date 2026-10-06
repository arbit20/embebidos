import 'package:flutter/material.dart';

import '../core/format/fechas.dart';
import '../core/theme/app_theme.dart';
import '../data/models/paciente.dart';

class PacienteTile extends StatelessWidget {
  const PacienteTile({
    super.key,
    required this.paciente,
    required this.ultimaConsulta,
    required this.onTap,
  });

  final Paciente paciente;
  final DateTime? ultimaConsulta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final detalle = ultimaConsulta == null
        ? 'CI: ${paciente.ci} · Sin consultas'
        : 'CI: ${paciente.ci} · Última consulta: ${fechaCorta(ultimaConsulta!)}';

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: AppColors.azulSuave,
        foregroundColor: AppColors.azul,
        child: Text(
          iniciales(paciente.nombre),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      title: Text(
        paciente.nombre,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(detalle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
