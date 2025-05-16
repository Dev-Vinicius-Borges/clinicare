import 'package:clini_care/components/agendamento/CardAgendamento.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendamentoFeitos extends StatefulWidget {
  @override
  _AgendamentoFeitosState createState() => _AgendamentoFeitosState();
}

class _AgendamentoFeitosState extends State<AgendamentoFeitos> {
  DateTime dataInicial = DateTime.now();
  DateTime? dataSelecionada;

  final List<Map<String, dynamic>> agendamentos = [
    {'data': DateTime(2025, 5, 24), 'horario': '08:00', 'nome': 'Dr. Silva', 'especialidade': 'Especialidade 1'},
    {'data': DateTime(2025, 5, 24), 'horario': '12:00', 'nome': 'Dra. Costa', 'especialidade': 'Especialidade 2'},
    {'data': DateTime(2025, 5, 24), 'horario': '14:00', 'nome': 'Dra. Costa', 'especialidade': 'Especialidade 1'},
    {'data': DateTime(2025, 5, 18), 'horario': '09:30', 'nome': 'Dr. Oliveira', 'especialidade': 'Especialidade 3'},
    {'data': DateTime(2025, 5, 22), 'horario': '10:00', 'nome': 'Dr. Lima', 'especialidade': 'Especialidade 5'},
    {'data': DateTime(2025, 5, 22), 'horario': '14:00', 'nome': 'Dr. Pereira', 'especialidade': 'Especialidade 6'},
  ];

  bool dataEstaDisponivel(DateTime day) {
    return agendamentos.any((agendamento) =>
    agendamento['data'].year == day.year &&
        agendamento['data'].month == day.month &&
        agendamento['data'].day == day.day);
  }

  List<Map<String, dynamic>> obterAgendamentos(DateTime? data) {
    return data != null
        ? agendamentos.where((agendamento) => isSameDay(agendamento['data'], data)).toList()
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          locale: 'pt_BR',
          firstDay: DateTime.now(),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: DateTime.now(),
          selectedDayPredicate: (day) =>
          dataSelecionada != null && isSameDay(dataSelecionada, day),
          onDaySelected: (selectedDay, focusedDay) {
            if (dataEstaDisponivel(selectedDay)) {
              setState(() {
                dataSelecionada = selectedDay;
                dataInicial = focusedDay;
              });
            }
          },
          calendarStyle: CalendarStyle(
            defaultDecoration: BoxDecoration(shape: BoxShape.circle),
            todayDecoration: BoxDecoration(
              color: Colors.blue.withValues(alpha:0.3),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Color.fromARGB(255, 88, 98, 151),
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle(color: Colors.black),
            disabledTextStyle: TextStyle(color: Colors.grey),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, _) {
              if (dataEstaDisponivel(day)) {
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 184, 194, 246),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
            },
          ),
          headerVisible: true,
          daysOfWeekVisible: true,
          pageJumpingEnabled: false,
          availableCalendarFormats: const {
            CalendarFormat.week: 'Semana',
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarFormat: CalendarFormat.week,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: obterAgendamentos(dataSelecionada).length,
            itemBuilder: (context, index) {
              var agendamento = obterAgendamentos(dataSelecionada)[index];

              return CardAgendamento(
                horario: agendamento['horario']!,
                nome: agendamento['nome']!,
                especialidade: agendamento['especialidade']!,
              );
            },
          ),
        ),
      ],
    );
  }
}
