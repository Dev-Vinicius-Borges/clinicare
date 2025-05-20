import 'dart:io';

import 'package:clini_care/components/BottomSheetContainer.dart';
import 'package:clini_care/components/bottomSheets/agendamento/EscolherDataDisponivel.dart';
import 'package:clini_care/components/bottomSheets/agendamento/EscolherHorarioDisponivel.dart';
import 'package:clini_care/server/Dtos/consulta/CriarConsultaDto.dart';
import 'package:clini_care/server/models/MedicoModel.dart';
import 'package:clini_care/server/services/ConsultaService.dart';
import 'package:clini_care/server/services/HorariosDisponiveisMedicosService.dart';
import 'package:clini_care/server/services/MedicoService.dart';
import 'package:clini_care/server/session/configuracao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmarAgendamento extends StatefulWidget {
  final int id_profissional;
  final String especialidade;
  final DateTime data_consulta;
  final TimeOfDay hora_consulta;

  const ConfirmarAgendamento(
    this.id_profissional,
    this.especialidade,
    this.data_consulta,
    this.hora_consulta, {
    super.key,
  });

  @override
  State<ConfirmarAgendamento> createState() => _ConfirmarAgendamentoState();
}

class _ConfirmarAgendamentoState extends State<ConfirmarAgendamento> {
  late MedicoModel medico;
  Map<DateTime, List<TimeOfDay>> horariosPorData = {};
  late int id_usuario;

  void buscarInfoMedico() async {
    var busca = await MedicoService().buscarMedicoPorId(widget.id_profissional);
    setState(() {
      medico = busca.Dados!;
    });
  }

  void buscarCliente() {
    id_usuario =
        Provider.of<GerenciadorDeSessao>(context, listen: false).idUsuario!;
  }

  Future<void> buscarHorariosDisponiveis() async {
    var resposta = await HorariosDisponiveisMedicosService()
        .buscarHorariosPorIdMedico(widget.id_profissional);

    if (resposta.Status == HttpStatus.ok && resposta.Dados != null) {
      Map<DateTime, List<TimeOfDay>> tempHorariosPorData = {};

      for (var horario in resposta.Dados!) {
        DateTime data = horario.data_real;
        TimeOfDay hora = horario.horario;

        if (!tempHorariosPorData.containsKey(data)) {
          tempHorariosPorData[data] = [];
        }
        tempHorariosPorData[data]!.add(hora);
      }

      setState(() {
        horariosPorData = tempHorariosPorData;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    buscarInfoMedico();
    buscarHorariosDisponiveis();
    buscarCliente();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  medico.foto_medico!,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Icon(Icons.person, size: 100),
                ),
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medico.nome,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  widget.especialidade,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 20),
                SizedBox(width: 5),
                Text(
                  "Data",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () async {
                await buscarHorariosDisponiveis();
                Navigator.pop(context, widget.data_consulta);
                showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  isScrollControlled: true,
                  builder:
                      (context) => BottomSheetContainer(
                        "Escolha uma data",
                        EscolherDataDisponivel(
                          widget.id_profissional,
                          horariosPorData,
                        ),
                      ),
                );
              },
              icon: Icon(Icons.edit, size: 16, color: Colors.white),
              label: Text(
                "Editar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 160, 173, 243),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 22.0),
            child: Text(
              "${widget.data_consulta.day}/${widget.data_consulta.month}/${widget.data_consulta.year}",
              style: TextStyle(fontSize: 13, color: Colors.black),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, size: 20),
                SizedBox(width: 5),
                Text(
                  "Horário",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context, widget.hora_consulta);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder:
                      (context) => BottomSheetContainer(
                        "Escolha um horário",
                        EscolherHorarioDisponivel(
                          id_profissional: widget.id_profissional,
                          dataEscolhida: widget.data_consulta,
                          horarios: horariosPorData[widget.data_consulta] ?? [],
                        ),
                      ),
                );
              },
              icon: Icon(Icons.edit, size: 16, color: Colors.white),
              label: Text(
                "Editar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 160, 173, 243),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 22.0),
            child: Text(
              '${widget.hora_consulta.hour.toString().padLeft(2, '0')}:${widget.hora_consulta.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.radio_button_checked, color: Colors.blue, size: 16),
            SizedBox(width: 6),
            Expanded(child: Text("Desejo receber uma confirmação por SMS.")),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            CriarConsultaDto novaConsulta = new CriarConsultaDto(
              data_consulta: widget.data_consulta,
              id_cliente: id_usuario,
              id_medico: medico.id,
            );

            var agendamento = await ConsultaService().criarConsulta(
              novaConsulta,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(agendamento.Mensagem.toString())),
            );

            if (agendamento.Status == HttpStatus.created) {
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 64, 91, 230),
            minimumSize: Size(double.infinity, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Agendar consulta",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
