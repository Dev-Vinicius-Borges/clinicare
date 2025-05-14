import 'package:clini_care/components/BottomSheetContainer.dart';
import 'package:clini_care/components/bottomSheets/agendamento/ConfirmarAgendamento.dart';
import 'package:clini_care/components/bottomSheets/agendamento/EscolherDataDisponivel.dart';
import 'package:flutter/material.dart';

class EscolherHorarioDisponivel extends StatefulWidget {
  const EscolherHorarioDisponivel({super.key});

  @override
  State<EscolherHorarioDisponivel> createState() =>
      _EscolherHorarioDisponivelState();
}

class _EscolherHorarioDisponivelState extends State<EscolherHorarioDisponivel> {
  final List<String> horariosDisponiveis = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
  ];

  String? horarioSelecionado;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                horariosDisponiveis.map((horario) {
                  final selecionado = horario == horarioSelecionado;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        horarioSelecionado = horario;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            selecionado
                                ? const Color(0xFF585E97)
                                : const Color(0xFFE5E7FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        horario,
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
          const SizedBox(height: 24),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Horário",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    horarioSelecionado ?? "--:--",
                    style: const TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
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
                                      1,
                                      "Especialidade 1",
                                      DateTime(2025, 05, 14),
                                      14,
                                    ),
                                    voltarParaBottomSheetAnterior: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: false,
                                        builder:
                                            (context) => BottomSheetContainer(
                                              "Escolha um horário",
                                              const EscolherHorarioDisponivel(),
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
                        return const Color(0xFFBFC9FF); // desativado
                      }
                      return const Color(0xFF405BE6); // ativo
                    }),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    elevation: const WidgetStatePropertyAll(0),
                  ),
                  child: const Text(
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
