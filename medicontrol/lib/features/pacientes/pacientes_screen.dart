import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../widgets/paciente_tile.dart';
import '../clinica/clinica_controller.dart';

class PacientesScreen extends StatefulWidget {
  const PacientesScreen({super.key});

  @override
  State<PacientesScreen> createState() => _PacientesScreenState();
}

class _PacientesScreenState extends State<PacientesScreen> {
  final _busqueda = TextEditingController();

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clinica = context.watch<ClinicaController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Registrar paciente',
        onPressed: () => context.push('/paciente/nuevo'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              key: const Key('buscar-paciente'),
              controller: _busqueda,
              onChanged: clinica.buscar,
              decoration: const InputDecoration(
                hintText: 'Buscar paciente...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: clinica.refrescar,
              child: clinica.lista.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 80),
                        Center(
                          child: Text(
                            'No hay pacientes que coincidan con la búsqueda.',
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 88),
                      itemCount: clinica.lista.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final paciente = clinica.lista[index];
                        return PacienteTile(
                          paciente: paciente,
                          ultimaConsulta: clinica.ultimaConsultaDe(
                            paciente.id!,
                          ),
                          onTap: () => context.push('/paciente/${paciente.id}'),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
