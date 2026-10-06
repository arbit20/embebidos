import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../widgets/tarjeta.dart';
import '../auth/auth_controller.dart';

class MasScreen extends StatelessWidget {
  const MasScreen({super.key});

  Future<void> _cerrar(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text(
            '¿Quieres salir de MediControl en este dispositivo?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );
    if (confirmar == true && context.mounted) {
      await context.read<AuthController>().cerrarSesion();
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthController>().usuario;

    return Scaffold(
      appBar: AppBar(title: const Text('Más')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Tarjeta(
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.azulSuave,
                  foregroundColor: AppColors.azul,
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usuario?.nombre ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        usuario?.correo ?? '',
                        style: const TextStyle(color: AppColors.textoSuave),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _cerrar(context),
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
