import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/format/fechas.dart';
import '../../data/local/semilla.dart';
import '../../data/models/cita.dart';
import '../clinica/clinica_controller.dart';

class CitaFormScreen extends StatefulWidget {
  const CitaFormScreen({super.key, this.pacienteId});

  final int? pacienteId;

  @override
  State<CitaFormScreen> createState() => _CitaFormScreenState();
}

class _CitaFormScreenState extends State<CitaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notas = TextEditingController();
  int? _pacienteId;
  DateTime? _fecha;
  TimeOfDay? _hora;
  String? _motivo;
  bool _guardando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _pacienteId = widget.pacienteId;
  }

  @override
  void dispose() {
    _notas.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final hoy = DateTime.now();
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fecha ?? hoy,
      firstDate: DateTime(hoy.year, hoy.month, hoy.day),
      lastDate: DateTime(hoy.year + 2),
      helpText: 'Fecha de la cita',
    );
    if (elegida != null) {
      setState(() => _fecha = elegida);
    }
  }

  Future<void> _elegirHora() async {
    final elegida = await showTimePicker(
      context: context,
      initialTime: _hora ?? TimeOfDay.now(),
      helpText: 'Hora de la cita',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (elegida != null) {
      setState(() => _hora = elegida);
    }
  }

  Future<void> _guardar() async {
    final formularioValido = _formKey.currentState!.validate();
    if (_fecha == null || _hora == null) {
      setState(() => _error = 'Selecciona la fecha y la hora');
      return;
    }
    if (!formularioValido || _pacienteId == null || _motivo == null) {
      return;
    }

    final fechaHora = DateTime(
      _fecha!.year,
      _fecha!.month,
      _fecha!.day,
      _hora!.hour,
      _hora!.minute,
    );
    if (!fechaHora.isAfter(DateTime.now())) {
      setState(() => _error = 'La cita debe quedar en el futuro');
      return;
    }

    setState(() {
      _guardando = true;
      _error = null;
    });
    final clinica = context.read<ClinicaController>();
    final paciente = clinica.catalogo
        .where((p) => p.id == _pacienteId)
        .firstOrNull;
    try {
      await clinica.agregarCita(
        Cita(
          pacienteId: _pacienteId!,
          pacienteNombre: paciente?.nombre ?? '',
          fechaHora: fechaHora,
          motivo: _motivo!,
          notas: _notas.text,
        ),
      );
      if (mounted) {
        context.pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'No se pudo guardar la cita');
      }
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pacientes = context.watch<ClinicaController>().catalogo;
    final fechaTexto = _fecha == null
        ? 'Seleccionar fecha'
        : fechaCorta(_fecha!);
    final horaTexto = _hora == null
        ? 'Seleccionar hora'
        : horaCorta(DateTime(0, 1, 1, _hora!.hour, _hora!.minute));

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva cita')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            DropdownButtonFormField<int>(
              initialValue: pacientes.any((p) => p.id == _pacienteId)
                  ? _pacienteId
                  : null,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Paciente'),
              items: [
                for (final paciente in pacientes)
                  DropdownMenuItem(
                    value: paciente.id,
                    child: Text(paciente.nombre),
                  ),
              ],
              onChanged: (valor) => setState(() => _pacienteId = valor),
              validator: (valor) =>
                  valor == null ? 'Selecciona un paciente' : null,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _elegirFecha,
              icon: const Icon(Icons.event_outlined),
              label: Text(fechaTexto),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _elegirHora,
              icon: const Icon(Icons.schedule),
              label: Text(horaTexto),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _motivo,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Motivo de la consulta',
              ),
              items: [
                for (final motivo in motivosDeCita)
                  DropdownMenuItem(value: motivo, child: Text(motivo)),
              ],
              onChanged: (valor) => setState(() => _motivo = valor),
              validator: (valor) =>
                  valor == null ? 'Selecciona el motivo' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notas,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Notas (opcional)',
                alignLabelWithHint: true,
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _guardando ? null : _guardar,
              child: Text(_guardando ? 'Guardando...' : 'Guardar cita'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
