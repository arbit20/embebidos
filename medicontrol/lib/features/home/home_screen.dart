import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/format/fechas.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/tarjeta.dart';
import '../auth/auth_controller.dart';
import '../clinica/clinica_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final clinica = context.watch<ClinicaController>();
    final proxima = clinica.proxima;
    final nombre = auth.usuario?.nombre ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('MediControl'),
        actions: [
          IconButton(
            tooltip: 'Notificaciones',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Los recordatorios estarán disponibles en una próxima versión.',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: clinica.refrescar,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            Text(
              'Hola, $nombre',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '¿Qué deseas hacer hoy?',
              style: TextStyle(color: AppColors.textoSuave),
            ),
            const SizedBox(height: 18),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                _Acceso(
                  titulo: 'Pacientes',
                  icono: Icons.people_alt_rounded,
                  fondo: const Color(0xFFE7F0FE),
                  tinta: AppColors.azul,
                  onTap: () => context.go('/pacientes'),
                ),
                _Acceso(
                  titulo: 'Citas',
                  icono: Icons.calendar_month_rounded,
                  fondo: const Color(0xFFEDE7F6),
                  tinta: const Color(0xFF6A4C93),
                  onTap: () => context.go('/citas'),
                ),
                _Acceso(
                  titulo: 'Historial médico',
                  icono: Icons.description_outlined,
                  fondo: const Color(0xFFE7F6F1),
                  tinta: const Color(0xFF1B8A5A),
                  onTap: () => context.push('/historial'),
                ),
                _Acceso(
                  titulo: 'Tratamientos',
                  icono: Icons.medication_outlined,
                  fondo: const Color(0xFFFDECEC),
                  tinta: const Color(0xFFC4475A),
                  onTap: () => context.push('/tratamientos'),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Text(
              'Próxima cita',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            if (proxima == null)
              const Tarjeta(
                child: Text(
                  'No hay citas programadas.',
                  style: TextStyle(color: AppColors.textoSuave),
                ),
              )
            else
              Tarjeta(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.azulSuave,
                      foregroundColor: AppColors.azul,
                      child: Text(
                        iniciales(proxima.pacienteNombre),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            proxima.pacienteNombre,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            cuando(proxima.fechaHora, DateTime.now()),
                            style: const TextStyle(color: AppColors.textoSuave),
                          ),
                          Text(
                            proxima.motivo,
                            style: const TextStyle(color: AppColors.azul),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Acceso extends StatelessWidget {
  const _Acceso({
    required this.titulo,
    required this.icono,
    required this.fondo,
    required this.tinta,
    required this.onTap,
  });

  final String titulo;
  final IconData icono;
  final Color fondo;
  final Color tinta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: fondo,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icono, color: tinta, size: 30),
              const Spacer(),
              Text(
                titulo,
                style: TextStyle(color: tinta, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
