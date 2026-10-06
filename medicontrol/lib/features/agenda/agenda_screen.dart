import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/format/fechas.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/cita_tile.dart';
import '../clinica/clinica_controller.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime _focused = DateTime.now();
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final clinica = context.watch<ClinicaController>();
    final delDia = clinica.citasDelDia(_selected);
    final tituloDia = mismoDia(_selected, DateTime.now())
        ? 'Citas de hoy'
        : 'Citas del ${fechaCorta(_selected)}';

    return Scaffold(
      appBar: AppBar(title: const Text('Agenda')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/cita/nueva'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva cita'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borde),
            ),
            child: TableCalendar(
              locale: 'es_ES',
              firstDay: DateTime(2024),
              lastDay: DateTime(2030, 12, 31),
              focusedDay: _focused,
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) => mismoDia(day, _selected),
              eventLoader: clinica.citasDelDia,
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {CalendarFormat.month: 'Mes'},
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: AppColors.azul.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: AppColors.azul,
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: AppColors.azul,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 1,
              ),
              onDaySelected: (selected, focused) {
                setState(() {
                  _selected = selected;
                  _focused = focused;
                });
              },
              onPageChanged: (focused) => _focused = focused,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            tituloDia,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          if (delDia.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                'No hay citas para este día.',
                style: TextStyle(color: AppColors.textoSuave),
              ),
            )
          else
            ...delDia.map((cita) => CitaTile(cita: cita)),
        ],
      ),
    );
  }
}
