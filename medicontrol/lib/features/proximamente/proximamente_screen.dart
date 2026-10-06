import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

class ProximamenteScreen extends StatelessWidget {
  const ProximamenteScreen({
    super.key,
    required this.titulo,
    required this.detalle,
  });

  final String titulo;
  final String detalle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction_outlined,
              size: 64,
              color: AppColors.azul,
            ),
            const SizedBox(height: 16),
            Text(
              titulo,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              detalle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textoSuave),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.pop(),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
