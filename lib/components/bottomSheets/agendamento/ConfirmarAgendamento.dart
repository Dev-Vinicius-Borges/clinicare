import 'dart:io';
import 'package:clini_care/components/BottomSheetContainer.dart';
import 'package:clini_care/components/bottomSheets/agendamento/EscolherDataDisponivel.dart';
import 'package:clini_care/components/bottomSheets/agendamento/EscolherHorarioDisponivel.dart';
import 'package:clini_care/server/Dtos/consulta/CriarConsultaDto.dart';
import 'package:clini_care/server/models/MedicoModel.dart';
import 'package:clini_care/server/services/ConsultaService.dart';
import 'package:clini_care/server/services/HorariosDisponiveisMedicosService.dart';
import 'package:clini_care/server/session/configuracao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmarAgendamento extends StatefulWidget {
  final MedicoModel medico;
  final DateTime data_consulta;
  final TimeOfDay hora_consulta;

  const ConfirmarAgendamento(
    this.medico,
    this.data_consulta,
    this.hora_consulta, {
    super.key,
  });

  @override
  State<ConfirmarAgendamento> createState() => _ConfirmarAgendamentoState();
}

class _ConfirmarAgendamentoState extends State<ConfirmarAgendamento> {
  Map<DateTime, List<TimeOfDay>> horariosPorData = {};
  late int id_usuario;
  bool isLoading = true;
  late DateTime data_consulta;
  late TimeOfDay hora_consulta;
  late MedicoModel medico;

  void buscarCliente() {
    id_usuario =
        Provider.of<GerenciadorDeSessao>(context, listen: false).idUsuario!;
  }

  Future<void> buscarHorariosDisponiveis() async {
    setState(() {
      isLoading = true;
    });

    try {
      var resposta = await HorariosDisponiveisMedicosService()
          .buscarHorariosPorIdMedico(medico.id);

      if (resposta.Status == HttpStatus.ok && resposta.Dados != null) {
        Map<DateTime, List<TimeOfDay>> tempHorariosPorData = {};

        for (var horario in resposta.Dados!) {
          DateTime dataNormalizada = DateTime(
            horario.data_real.year,
            horario.data_real.month,
            horario.data_real.day,
          );
          
          TimeOfDay hora = horario.horario;

          if (!tempHorariosPorData.containsKey(dataNormalizada)) {
            tempHorariosPorData[dataNormalizada] = [];
          }
          tempHorariosPorData[dataNormalizada]!.add(hora);
        }

        setState(() {
          horariosPorData = tempHorariosPorData;
        });
        
        await buscarConsultasExistentes();
        
        if (horariosPorData.isEmpty) {
          _adicionarDadosPadrao();
        }
        
        setState(() {
          isLoading = false;
        });
      } else {
        _adicionarDadosPadrao();
        
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      _adicionarDadosPadrao();
      
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> buscarConsultasExistentes() async {
    try {
      var resposta = await ConsultaService().listarConsultas();

      if (resposta.Status == HttpStatus.ok && resposta.Dados != null) {
        Map<DateTime, List<TimeOfDay>> horariosPorDataCopia = Map.from(horariosPorData);
        
        for (var consulta in resposta.Dados!) {
          if (consulta.id_medico == medico.id) {
            DateTime dataConsulta = consulta.data_consulta;
            
            for (var data in horariosPorDataCopia.keys) {
              if (isSameDay(data, dataConsulta)) {
                int hora = dataConsulta.hour;
                int minuto = dataConsulta.minute;

                horariosPorData[data]?.removeWhere(
                  (horario) => horario.hour == hora && horario.minute == minuto,
                );

                if (horariosPorData[data]?.isEmpty ?? true) {
                  horariosPorData.remove(data);
                }
              }
            }
          }
        }
      }
    } catch (e) {
    }
  }

  @override
  void initState() {
    super.initState();
    medico = widget.medico;
    data_consulta = widget.data_consulta;
    hora_consulta = widget.hora_consulta;
    buscarCliente();
    buscarHorariosDisponiveis();
  }
  
  void _adicionarDadosPadrao() {
    DateTime hoje = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    
    for (int i = 0; i < 10; i++) {
      DateTime data = hoje.add(Duration(days: i));
      
      if (data.weekday >= 6) continue;
      
      horariosPorData[data] = [
        TimeOfDay(hour: 9, minute: 0),
        TimeOfDay(hour: 10, minute: 0),
        TimeOfDay(hour: 11, minute: 0),
        TimeOfDay(hour: 14, minute: 0),
        TimeOfDay(hour: 15, minute: 0),
        TimeOfDay(hour: 16, minute: 0),
      ];
    }
  }

  void _editarData() async {
    if (isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Aguarde, carregando horários disponíveis...")),
      );
      return;
    }
    
    if (horariosPorData.isEmpty) {
      _adicionarDadosPadrao();
    }
    
    final result = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BottomSheetContainer(
          'Escolha uma data',
          EscolherDataDisponivel(medico.id, horariosPorData),
        );
      },
    );
    
    if (result != null) {
      setState(() {
        data_consulta = result;
      });
      
      _editarHorario();
    }
  }

  void _editarHorario() async {
    if (isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Aguarde, carregando horários disponíveis...")),
      );
      return;
    }
    
    List<TimeOfDay> horariosDisponiveis = [];
    
    for (var data in horariosPorData.keys) {
      if (isSameDay(data, data_consulta)) {
        horariosDisponiveis = horariosPorData[data] ?? [];
        break;
      }
    }
    
    if (horariosDisponiveis.isEmpty) {
      horariosDisponiveis = [
        TimeOfDay(hour: 9, minute: 0),
        TimeOfDay(hour: 10, minute: 0),
        TimeOfDay(hour: 11, minute: 0),
        TimeOfDay(hour: 14, minute: 0),
        TimeOfDay(hour: 15, minute: 0),
        TimeOfDay(hour: 16, minute: 0),
      ];
    }
    
    final result = await showModalBottomSheet<TimeOfDay>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BottomSheetContainer(
          "Escolha um horário",
          EscolherHorarioDisponivel(
            id_profissional: medico.id,
            dataEscolhida: data_consulta,
            horarios: horariosDisponiveis,
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        hora_consulta = result;
      });
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      medico.especialidade,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: _editarData,
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
                  "${data_consulta.day}/${data_consulta.month}/${data_consulta.year}",
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: _editarHorario,
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
                  '${hora_consulta.hour.toString().padLeft(2, '0')}:${hora_consulta.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.radio_button_checked, color: Colors.blue, size: 16),
                SizedBox(width: 6),
                Expanded(
                  child: Text("Desejo receber uma confirmação por SMS."),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });

                DateTime dataHoraConsulta = DateTime(
                  data_consulta.year,
                  data_consulta.month,
                  data_consulta.day,
                  hora_consulta.hour,
                  hora_consulta.minute,
                );

                CriarConsultaDto novaConsulta = new CriarConsultaDto(
                  data_consulta: dataHoraConsulta,
                  id_cliente: id_usuario,
                  id_medico: medico.id,
                );

                var agendamento = await ConsultaService().criarConsulta(
                  novaConsulta,
                );

                setState(() {
                  isLoading = false;
                });

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
              child:
                  isLoading
                      ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
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
