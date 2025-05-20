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

  @override
  void initState() {
    super.initState();
    _datasDisponiveis = widget.horariosDisponiveis;
  }

  bool dataEstaDisponivel(DateTime day) {
    return _datasDisponiveis.containsKey(day);
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
                                    EscolherHorarioDisponivel(
                                      dataEscolhida: dataEscolhida!,
                                      id_profissional: widget.id_profissional,
                                      horarios:
                                          _datasDisponiveis[dataEscolhida!]!,
                                    ),
                                  ),
                            );
                          }
                          : null,
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
