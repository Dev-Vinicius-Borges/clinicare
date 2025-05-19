import 'dart:io';

import 'package:clini_care/components/BottomSheetContainer.dart';
import 'package:clini_care/components/bottomSheets/agendamento/EscolherHorarioDisponivel.dart';
import 'package:clini_care/server/services/HorariosDisponiveisMedicosService.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class EscolherDataDisponivel extends StatefulWidget {
  final int id_profissional;

  const EscolherDataDisponivel(this.id_profissional, {super.key});

  @override
  State<EscolherDataDisponivel> createState() => _EscolherDataDisponivelState();
}

class _EscolherDataDisponivelState extends State<EscolherDataDisponivel> {
  DateTime dataInicial = DateTime.now();
  DateTime? dataEscolhida;
  final List<DateTime> _datasDisponiveis = [];

  void buscarDatasDisponiveis() async {
    var resposta = await HorariosDisponiveisMedicosService().buscarHorariosPorIdMedico(widget.id_profissional);

    if (resposta.Status == HttpStatus.ok) {
      setState(() {
        _datasDisponiveis.clear();
        resposta.Dados?.forEach((horario) {
          _datasDisponiveis.addAll(_todasOcorrenciasDoDia(horario.dia_semana));
        });
      });
    }
  }


  List<DateTime> _todasOcorrenciasDoDia(String diaSemana) {
    final dias = {
      'Domingo': DateTime.sunday,
      'Segunda': DateTime.monday,
      'Terca': DateTime.tuesday,
      'Quarta': DateTime.wednesday,
      'Quinta': DateTime.thursday,
      'Sexta': DateTime.friday,
      'Sabado': DateTime.saturday,
    };

    DateTime hoje = DateTime.now();
    DateTime fimDoMes = DateTime(hoje.year, hoje.month + 1, 0);
    int diaSemanaInt = dias[diaSemana] ?? DateTime.monday;

    List<DateTime> datas = [];

    while (hoje.isBefore(fimDoMes) || isSameDay(hoje, fimDoMes)) {
      if (hoje.weekday == diaSemanaInt) {
        datas.add(hoje);
      }
      hoje = hoje.add(Duration(days: 1));
    }

    return datas;
  }



  bool dataEstaDisponivel(DateTime day) {
    return _datasDisponiveis.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
  }

  @override
  void initState() {
    super.initState();
    buscarDatasDisponiveis();
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
                        : 'Nenhuma data selecionada',
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
                      dataEscolhida != null
                          ? () {
                            Navigator.pop(context, dataEscolhida);

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder:
                                  (context) => BottomSheetContainer(
                                    "Escolha um horário",
                                    EscolherHorarioDisponivel(dataEscolhida: dataEscolhida!, id_profissional: widget.id_profissional,),
                                    voltarParaBottomSheetAnterior: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder:
                                            (context) => BottomSheetContainer(
                                              "Escolha uma data",
                                              EscolherDataDisponivel(widget.id_profissional),
                                            ),
                                      );
                                    },
                                  ),
                            );
                          }
                          : null,
                  style: ButtonStyle(
                    elevation: WidgetStatePropertyAll<double>(0),
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      dataEscolhida != null
                          ? Color.fromARGB(255, 64, 91, 230)
                          : Color.fromARGB(255, 180, 190, 250),
                    ),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: Text(
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
