import 'package:clini_care/components/BottomSheetContainer.dart';
import 'package:clini_care/components/bottomSheets/agendamento/EscolherHorario.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class EscolherDataDisponivel extends StatefulWidget {
  const EscolherDataDisponivel({super.key});

  @override
  State<EscolherDataDisponivel> createState() => _EscolherDataDisponivelState();
}

class _EscolherDataDisponivelState extends State<EscolherDataDisponivel> {
  DateTime dataInicial = DateTime.now();
  DateTime? dataEscolhida;

  final List<DateTime> _datasDisponiveis = [
    DateTime(2025, 5, 14),
    DateTime(2025, 5, 18),
    DateTime(2025, 5, 22),
    DateTime(2025, 5, 24),
    DateTime(2025, 5, 31),
  ];

  bool dataEstaDisponivel(DateTime day) {
    return _datasDisponiveis.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: dataInicial,
            selectedDayPredicate:
                (day) => dataEscolhida != null && isSameDay(dataEscolhida, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (dataEstaDisponivel(selectedDay)) {
                setState(() {
                  dataEscolhida = selectedDay;
                  dataInicial = focusedDay;
                });
              }
            },
            calendarStyle: CalendarStyle(
              defaultDecoration: BoxDecoration(shape: BoxShape.circle),
              todayDecoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 88, 98, 151),
                shape: BoxShape.circle,
              ),
              weekendTextStyle: const TextStyle(color: Colors.black),
              disabledTextStyle: const TextStyle(color: Colors.grey),
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
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Data",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    dataEscolhida != null
                        ? DateFormat('dd/MM/yyyy').format(dataEscolhida!)
                        : 'Nenhuma data selecionada',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 195,
                height: 60,
                child: ElevatedButton(
                  onPressed:
                      dataEscolhida != null
                          ? () {
                            Navigator.pop(context, dataEscolhida);

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder:
                                  (context) => BottomSheetContainer(
                                    "Escolha um horário",
                                    const EscolherHorarioDisponivel(),
                                    voltarParaBottomSheetAnterior: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder:
                                            (context) => BottomSheetContainer(
                                              "Escolha uma data",
                                              const EscolherDataDisponivel(),
                                            ),
                                      );
                                    },
                                  ),
                            );
                          }
                          : null,
                  style: ButtonStyle(
                    elevation: const WidgetStatePropertyAll<double>(0),
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      dataEscolhida != null
                          ? const Color.fromARGB(255, 64, 91, 230)
                          : const Color.fromARGB(255, 180, 190, 250),
                    ),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
