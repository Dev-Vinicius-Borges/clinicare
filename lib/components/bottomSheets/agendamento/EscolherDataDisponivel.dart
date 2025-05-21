import 'package:clini_care/components/BottomSheetContainer.dart';
import 'package:clini_care/components/bottomSheets/agendamento/EscolherHorarioDisponivel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EscolherDataDisponivel extends StatefulWidget {
  final int id_profissional;
  final Map<DateTime, List<TimeOfDay>> horariosDisponiveis;

  const EscolherDataDisponivel(
    this.id_profissional,
    this.horariosDisponiveis, {
    super.key,
  });

  @override
  State<EscolherDataDisponivel> createState() => _EscolherDataDisponivelState();
}

class _EscolherDataDisponivelState extends State<EscolherDataDisponivel> {
  DateTime dataInicial = DateTime.now();
  DateTime? dataEscolhida;
  late Map<DateTime, List<TimeOfDay>> _datasDisponiveis;

  late DateTime dataLimite;

  @override
  void initState() {
    super.initState();
    _processarDatasDisponiveis();

    dataLimite = DateTime.now().add(Duration(days: 30));

    _datasDisponiveis.keys.forEach((data) {
      print(
        "${DateFormat('dd/MM/yyyy').format(data)} - ${_datasDisponiveis[data]!.length} horários",
      );
    });
  }

  void _processarDatasDisponiveis() {
    Map<DateTime, List<TimeOfDay>> datasProcessadas = {};

    for (var entrada in widget.horariosDisponiveis.entries) {
      DateTime dataNormalizada = DateTime(
        entrada.key.year,
        entrada.key.month,
        entrada.key.day,
      );

      Set<String> horariosUnicos = {};
      List<TimeOfDay> horariosProcessados = [];

      for (var horario in entrada.value) {
        String chaveHorario = '${horario.hour}:${horario.minute}';
        if (!horariosUnicos.contains(chaveHorario)) {
          horariosUnicos.add(chaveHorario);
          horariosProcessados.add(horario);
        }
      }

      datasProcessadas[dataNormalizada] = horariosProcessados;
    }

    _datasDisponiveis = datasProcessadas;
  }

  bool _ehDiaUtil(DateTime date) {
    return date.weekday >= 1 && date.weekday <= 5;
  }

  bool _estaDentroDoLimite(DateTime date) {
    return date.isBefore(dataLimite) || isSameDay(date, dataLimite);
  }

  bool dataEstaDisponivel(DateTime day) {
    if (!_ehDiaUtil(day) || !_estaDentroDoLimite(day)) {
      return false;
    }

    for (DateTime data in _datasDisponiveis.keys) {
      if (isSameDay(data, day)) {
        return true;
      }
    }
    return false;
  }

  List<TimeOfDay>? getHorariosParaData(DateTime day) {
    for (DateTime data in _datasDisponiveis.keys) {
      if (isSameDay(data, day)) {
        return _datasDisponiveis[data];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime.now(),
            lastDay: dataLimite,
            focusedDay: dataInicial,
            selectedDayPredicate:
                (day) =>
                    dataEscolhida != null && isSameDay(dataEscolhida!, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (dataEstaDisponivel(selectedDay)) {
                setState(() {
                  dataEscolhida = selectedDay;
                  dataInicial = focusedDay;
                });
              }
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
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
                  return null;
                }
              },
              disabledBuilder: (context, day, focusedDay) {
                return Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
                  ),
                );
              },
            ),
            enabledDayPredicate: (day) {
              return dataEstaDisponivel(day);
            },
          ),
          SizedBox(height: 16),
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
                        : 'dd/MM/yyyy',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: 195,
                height: 60,
                child: ElevatedButton(
                  onPressed:
                      dataEscolhida != null &&
                              dataEstaDisponivel(dataEscolhida!)
                          ? () {
                            Navigator.pop(context, dataEscolhida);

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder:
                                  (context) => BottomSheetContainer(
                                    "Escolha um horário",
                                    EscolherHorarioDisponivel(
                                      dataEscolhida: dataEscolhida!,
                                      id_profissional: widget.id_profissional,
                                      horarios:
                                          getHorariosParaData(dataEscolhida!)!,
                                    ),
                                  ),
                            );
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        dataEscolhida != null &&
                                dataEstaDisponivel(dataEscolhida!)
                            ? const Color.fromARGB(255, 64, 91, 230)
                            : Colors.grey.shade400,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
