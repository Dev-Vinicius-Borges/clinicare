import 'dart:io';

import 'package:clini_care/components/BottomSheetContainer.dart';
import 'package:clini_care/components/bottomSheets/agendamento/ConfirmarAgendamento.dart';
import 'package:clini_care/server/models/MedicoModel.dart';
import 'package:clini_care/server/services/HorariosDisponiveisMedicosService.dart';
import 'package:clini_care/server/services/MedicoService.dart';
import 'package:flutter/material.dart';

class EscolherHorarioDisponivel extends StatefulWidget {
  final int id_profissional;
  final DateTime dataEscolhida;

  EscolherHorarioDisponivel({
    super.key,
    required this.dataEscolhida,
    required this.id_profissional,
  });

  @override
  State<EscolherHorarioDisponivel> createState() =>
      _EscolherHorarioDisponivelState();
}

class _EscolherHorarioDisponivelState extends State<EscolherHorarioDisponivel> {
  List<TimeOfDay> horariosDisponiveis = [];
  late MedicoModel medico;
  TimeOfDay? horarioSelecionado;

  void buscarHorariosDisponiveis() async {
    var resposta = await HorariosDisponiveisMedicosService()
        .buscarHorariosPorIdMedico(widget.id_profissional);

    if (resposta.Status == HttpStatus.ok && resposta.Dados != null) {
      setState(() {
        horariosDisponiveis =
            resposta.Dados!.map((horario) => horario.horario).toSet().toList();
      });
    }
  }

  void buscarInformacoesMedico() async {
    var consulta = await MedicoService().buscarMedicoPorId(
      widget.id_profissional,
    );
    medico = consulta.Dados!;
  }

  @override
  void initState() {
    super.initState();
    buscarHorariosDisponiveis();
    buscarInformacoesMedico();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                horariosDisponiveis.map((TimeOfDay horario) {
                  final selecionado = horario == horarioSelecionado;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        horarioSelecionado = horario;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            selecionado ? Color(0xFF585E97) : Color(0xFFE5E7FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${horario.hour.toString().padLeft(2, '0')}:${horario.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: selecionado ? Colors.white : Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Horário",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    horarioSelecionado != null
                        ? '${horarioSelecionado!.hour.toString().padLeft(2, '0')}:${horarioSelecionado!.minute.toString().padLeft(2, '0')}'
                        : "--:--",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: 160,
                height: 55,
                child: ElevatedButton(
                  onPressed:
                      horarioSelecionado != null
                          ? () {
                            Navigator.pop(context, horarioSelecionado);
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              isDismissible: false,
                              builder:
                                  (context) => BottomSheetContainer(
                                    "Confirme o agendamento",
                                    ConfirmarAgendamento(
                                      medico.id,
                                      medico.especialidade,
                                      widget.dataEscolhida,
                                      horarioSelecionado!,
                                    ),
                                    voltarParaBottomSheetAnterior: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: false,
                                        builder:
                                            (context) => BottomSheetContainer(
                                              "Escolha um horário",
                                              EscolherHorarioDisponivel(
                                                id_profissional:
                                                    widget.id_profissional,
                                                dataEscolhida:
                                                    widget.dataEscolhida,
                                              ),
                                            ),
                                      );
                                    },
                                  ),
                            );
                          }
                          : null,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(WidgetState.disabled)) {
                        return Color(0xFFBFC9FF); // desativado
                      }
                      return Color(0xFF405BE6); // ativo
                    }),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    elevation: WidgetStatePropertyAll(0),
                  ),
                  child: Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
