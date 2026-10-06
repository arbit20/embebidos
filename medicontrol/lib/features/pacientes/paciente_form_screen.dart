import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/validators.dart';
import '../../data/models/paciente.dart';
import '../../data/repositories/paciente_repository.dart';
import '../clinica/clinica_controller.dart';

class PacienteFormScreen extends StatefulWidget {
  const PacienteFormScreen({super.key});

  @override
  State<PacienteFormScreen> createState() => _PacienteFormScreenState();
}

class _PacienteFormScreenState extends State<PacienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _ci = TextEditingController();
  final _telefono = TextEditingController();
  final _direccion = TextEditingController();
  DateTime? _nacimiento;
  bool _guardando = false;
  String? _error;

  @override
  void dispose() {
    _nombre.dispose();
    _ci.dispose();
    _telefono.dispose();
    _direccion.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final hoy = DateTime.now();
    final elegida = await showDatePicker(
      context: context,
      initialDate: _nacimiento ?? DateTime(hoy.year - 30, hoy.month, hoy.day),
      firstDate: DateTime(hoy.year - 110),
      lastDate: hoy,
      helpText: 'Fecha de nacimiento',
    );
    if (elegida != null) {
      setState(() => _nacimiento = elegida);
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _guardando = true;
      _error = null;
    });
    try {
      await context.read<ClinicaController>().agregarPaciente(
        Paciente(
          nombre: _nombre.text,
          ci: _ci.text,
          telefono: _telefono.text,
          fechaNacimiento: _nacimiento,
          direccion: _direccion.text,
        ),
      );
      if (mounted) {
        context.pop();
      }
    } on CiDuplicado {
      if (mounted) {
        setState(() => _error = 'Ya existe un paciente con ese CI');
      }
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final nacimiento = _nacimiento == null
        ? 'Opcional'
        : '${_nacimiento!.day.toString().padLeft(2, '0')}/${_nacimiento!.month.toString().padLeft(2, '0')}/${_nacimiento!.year}';

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo paciente')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            TextFormField(
              controller: _nombre,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Nombre completo'),
              validator: (valor) => validarRequerido(valor, 'el nombre'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _ci,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'CI'),
              validator: validarCi,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefono,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              validator: validarTelefono,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _direccion,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Dirección'),
              validator: (valor) => validarRequerido(valor, 'la dirección'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _elegirFecha,
              icon: const Icon(Icons.cake_outlined),
              label: Text('Nacimiento: $nacimiento'),
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
              child: Text(_guardando ? 'Guardando...' : 'Guardar paciente'),
            ),
          ],
        ),
      ),
    );
  }
}
