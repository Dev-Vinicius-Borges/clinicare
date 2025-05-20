import 'package:clini_care/components/BottomSheetContainer.dart';
import 'package:clini_care/components/bottomSheets/agendamento/EscolherDataDisponivel.dart';
import 'package:clini_care/server/models/HorariosDisponiveisMedicosModel.dart';
import 'package:clini_care/server/services/HorariosDisponiveisMedicosService.dart';
import 'package:flutter/material.dart';

class CardProfissional extends StatefulWidget {
  final int id_profissional;
  final String nome_profissional;
  final String especialidade_profissional;
  final String? fotoUrl;
  final bool viradoParaEsquerda;
  final bool ultimoCard;
  final List<HorariosDisponiveisMedicosModel> horariosDisponiveis;

  CardProfissional(
    this.id_profissional,
    this.nome_profissional,
    this.especialidade_profissional, {
    super.key,
    required this.viradoParaEsquerda,
    required this.ultimoCard,
    this.fotoUrl,
    required this.horariosDisponiveis,
  });

  @override
  State<CardProfissional> createState() => _CardProfissionalState();
}

class _CardProfissionalState extends State<CardProfissional> {
  @override
  Widget build(BuildContext context) {
    final imagem = Container(
      width: 150,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: widget.viradoParaEsquerda ? Radius.circular(16) : Radius.zero,
          right: widget.viradoParaEsquerda ? Radius.zero : Radius.circular(16),
        ),
      ),
      child:
          widget.fotoUrl != null && widget.fotoUrl!.isNotEmpty
              ? ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left:
                      widget.viradoParaEsquerda
                          ? Radius.circular(16)
                          : Radius.zero,
                  right:
                      widget.viradoParaEsquerda
                          ? Radius.zero
                          : Radius.circular(16),
                ),
                child: Image.network(
                  widget.fotoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Icon(Icons.person, size: 100),
                ),
              )
              : Container(
                color: Colors.grey,
                alignment: Alignment.center,
                child: Icon(Icons.person, size: 100),
              ),
    );

    final texto = Expanded(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              widget.viradoParaEsquerda
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment:
                  widget.viradoParaEsquerda
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
              children: [
                Text(
                  widget.nome_profissional,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.especialidade_profissional,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Map<DateTime, List<TimeOfDay>> horariosPorData = {};

                  for (var horario in widget.horariosDisponiveis) {
                    DateTime data = DateTime(
                      horario.data_real.year,
                      horario.data_real.month,
                      horario.data_real.day,
                    );
                    TimeOfDay hora = horario.horario;
                    if (!horariosPorData.containsKey(data)) {
                      horariosPorData[data] = [];
                    }
                    horariosPorData[data]!.add(hora);
                  }

                  showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return BottomSheetContainer(
                        'Escolha uma data',
                        EscolherDataDisponivel(
                          widget.id_profissional,
                          horariosPorData,
                        ),
                      );
                    },
                  );

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 64, 91, 230),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Agendar consulta",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: widget.viradoParaEsquerda ? [imagem, texto] : [texto, imagem],
      ),
    );
  }
}
