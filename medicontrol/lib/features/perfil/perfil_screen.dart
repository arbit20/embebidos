import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/format/fechas.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/paciente.dart';
import '../../widgets/cita_tile.dart';
import '../../widgets/tarjeta.dart';
import '../clinica/clinica_controller.dart';
import 'tratamiento_fijo.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key, required this.pacienteId});

  final int pacienteId;

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Paciente? _paciente;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargar());
  }

  Future<void> _cargar() async {
    final paciente = await context.read<ClinicaController>().obtenerPaciente(
      widget.pacienteId,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _paciente = paciente;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final clinica = context.watch<ClinicaController>();
    final paciente = _paciente;

    return Scaffold(
      appBar: AppBar(title: const Text('Información del paciente')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : paciente == null
          ? const Center(child: Text('No se encontró el paciente.'))
          : _Contenido(paciente: paciente, clinica: clinica),
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({required this.paciente, required this.clinica});

  final Paciente paciente;
  final ClinicaController clinica;

  @override
  Widget build(BuildContext context) {
    final hoy = DateTime.now();
    final edad = paciente.edadEn(hoy);
    final historial = clinica.historialDe(paciente.id!);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Center(
          child: CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.azulSuave,
            foregroundColor: AppColors.azul,
            child: Text(
              iniciales(paciente.nombre),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          paciente.nombre,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Center(
          child: Chip(
            label: Text(
              paciente.activo ? 'Paciente activo' : 'Paciente inactivo',
            ),
            backgroundColor: paciente.activo
                ? const Color(0xFFE5F6EC)
                : AppColors.azulSuave,
            side: BorderSide.none,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(height: 16),
        Tarjeta(
          child: Column(
            children: [
              _Dato(
                icono: Icons.cake_outlined,
                texto: edad == null ? 'Edad no registrada' : 'Edad: $edad años',
              ),
              _Dato(icono: Icons.badge_outlined, texto: 'CI: ${paciente.ci}'),
              _Dato(
                icono: Icons.phone_outlined,
                texto: 'Teléfono: ${paciente.telefono}',
              ),
              _Dato(
                icono: Icons.location_on_outlined,
                texto: 'Dirección: ${paciente.direccion}',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Historial médico',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        if (historial.isEmpty)
          const Text(
            'Sin consultas registradas.',
            style: TextStyle(color: AppColors.textoSuave),
          )
        else
          ...historial.map(
            (cita) => TarjetaCita(
              hora: fechaCorta(cita.fechaHora),
              titulo: cita.motivo,
              detalle: horaCorta(cita.fechaHora),
            ),
          ),
        const SizedBox(height: 12),
        const Text(
          'Tratamiento actual',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Tarjeta(child: Text(tratamientoFijo(paciente.id!))),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () =>
              context.push('/cita/nueva?pacienteId=${paciente.id}'),
          icon: const Icon(Icons.add),
          label: const Text('Nueva consulta'),
        ),
      ],
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icono, color: AppColors.azul, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(texto)),
        ],
      ),
    );
  }
}
