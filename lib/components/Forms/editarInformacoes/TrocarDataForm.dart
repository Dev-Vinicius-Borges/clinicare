import 'package:flutter/material.dart';
import 'package:clini_care/components/BottomSheetContainer.dart';
import 'package:clini_care/components/bottomSheets/agendamento/EscolherDataDisponivel.dart';
import 'package:clini_care/server/services/ConsultaService.dart';
import 'package:clini_care/server/services/HorariosDisponiveisMedicosService.dart';
import 'package:clini_care/server/Dtos/consulta/AtualizarConsultaDto.dart';

class TrocarDataForm extends StatefulWidget {
  final int idConsulta;
  final int idMedico;
  final DateTime dataAtual;
  final TimeOfDay horarioAtual;
  final Function onSucesso;

  const TrocarDataForm({
    Key? key,
    required this.idConsulta,
    required this.idMedico,
    required this.dataAtual,
    required this.horarioAtual,
    required this.onSucesso,
  }) : super(key: key);

  @override
  State<TrocarDataForm> createState() => _TrocarDataFormState();
}

class _TrocarDataFormState extends State<TrocarDataForm> {
  bool isLoading = true;
  Map<DateTime, List<TimeOfDay>> horariosPorData = {};
  DateTime? dataSelecionada;
  
  @override
  void initState() {
    super.initState();
    _buscarHorariosDisponiveis();
  }

  Future<void> _buscarHorariosDisponiveis() async {
    setState(() {
      isLoading = true;
    });

    try {
      var resposta = await HorariosDisponiveisMedicosService()
          .buscarHorariosPorIdMedico(widget.idMedico);

      if (resposta.Status == 200 && resposta.Dados != null) {
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

        await _buscarConsultasExistentes(tempHorariosPorData);
        
        if (tempHorariosPorData.isEmpty) {
          _adicionarDadosPadrao(tempHorariosPorData);
        }
        
        setState(() {
          horariosPorData = tempHorariosPorData;
          isLoading = false;
        });
      } else {
        Map<DateTime, List<TimeOfDay>> tempHorariosPorData = {};
        _adicionarDadosPadrao(tempHorariosPorData);
        
        setState(() {
          horariosPorData = tempHorariosPorData;
          isLoading = false;
        });
      }
    } catch (e) {
      Map<DateTime, List<TimeOfDay>> tempHorariosPorData = {};
      _adicionarDadosPadrao(tempHorariosPorData);
      
      setState(() {
        horariosPorData = tempHorariosPorData;
        isLoading = false;
      });
    }
  }

  Future<void> _buscarConsultasExistentes(Map<DateTime, List<TimeOfDay>> tempHorariosPorData) async {
    try {
      var resposta = await ConsultaService().listarConsultas();

      if (resposta.Status == 200 && resposta.Dados != null) {
        Map<DateTime, List<TimeOfDay>> horariosOcupados = {};
        
        for (var consulta in resposta.Dados!) {
          if (consulta.id_consulta == widget.idConsulta) continue;
          
          if (consulta.id_medico == widget.idMedico) {
            DateTime dataConsulta = consulta.data_consulta;
            
            DateTime dataNormalizada = DateTime(
              dataConsulta.year,
              dataConsulta.month,
              dataConsulta.day,
            );
            
            TimeOfDay horarioConsulta = TimeOfDay(
              hour: dataConsulta.hour,
              minute: dataConsulta.minute,
            );
            
            if (!horariosOcupados.containsKey(dataNormalizada)) {
              horariosOcupados[dataNormalizada] = [];
            }
            horariosOcupados[dataNormalizada]!.add(horarioConsulta);
            
            if (tempHorariosPorData.containsKey(dataNormalizada)) {
              tempHorariosPorData[dataNormalizada]?.removeWhere(
                (horario) => horario.hour == horarioConsulta.hour && horario.minute == horarioConsulta.minute,
              );
              
              if (tempHorariosPorData[dataNormalizada]?.isEmpty ?? true) {
                tempHorariosPorData.remove(dataNormalizada);
              }
            }
          }
        }
      }
    } catch (e) {
    }
  }
  
  void _adicionarDadosPadrao(Map<DateTime, List<TimeOfDay>> tempHorariosPorData) {
    DateTime hoje = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    
    for (int i = 0; i < 10; i++) {
      DateTime data = hoje.add(Duration(days: i));
      
      if (data.weekday >= 6) continue;
      
      tempHorariosPorData[data] = [
        TimeOfDay(hour: 9, minute: 0),
        TimeOfDay(hour: 10, minute: 0),
        TimeOfDay(hour: 11, minute: 0),
        TimeOfDay(hour: 14, minute: 0),
        TimeOfDay(hour: 15, minute: 0),
        TimeOfDay(hour: 16, minute: 0),
      ];
    }
  }

  Future<void> _atualizarData() async {
    if (dataSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecione uma data para continuar")),
      );
      return;
    }

    if (isSameDay(dataSelecionada!, widget.dataAtual)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Esta já é a data atual da consulta")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      DateTime novaDataHora = DateTime(
        dataSelecionada!.year,
        dataSelecionada!.month,
        dataSelecionada!.day,
        widget.horarioAtual.hour,
        widget.horarioAtual.minute,
      );

      AtualizarConsultaDto atualizarConsultaDto = AtualizarConsultaDto(
        id_consulta: widget.idConsulta,
        data_consulta: novaDataHora,
      );

      var resposta = await ConsultaService().atualizarConsulta(atualizarConsultaDto);

      setState(() {
        isLoading = false;
      });

      if (resposta.Status == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Data alterada com sucesso")),
        );
        Navigator.pop(context);
        widget.onSucesso();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resposta.Mensagem ?? "Erro ao alterar data")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao alterar data: $e")),
      );
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Selecione a nova data para sua consulta",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: EscolherDataDisponivel(
                  widget.idMedico,
                  horariosPorData,
                  onDataSelecionada: (data) {
                    setState(() {
                      dataSelecionada = data;
                    });
                  },
                ),
              ),
        SizedBox(height: 16),
        if (dataSelecionada != null)
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.blue),
                SizedBox(width: 12),
                Text(
                  "${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: isLoading ? null : _atualizarData,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 64, 91, 230),
            minimumSize: Size(double.infinity, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  "Confirmar nova data",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
}
