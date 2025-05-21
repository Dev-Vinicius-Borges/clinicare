import 'package:clini_care/server/session/configuracao.dart';
import 'package:flutter/material.dart';
import 'package:clini_care/server/services/ConsultaService.dart';
import 'package:clini_care/server/services/HorariosDisponiveisMedicosService.dart';
import 'package:clini_care/server/Dtos/consulta/AtualizarConsultaDto.dart';
import 'package:provider/provider.dart';

class TrocarHorarioForm extends StatefulWidget {
  final int idConsulta;
  final int idMedico;
  final DateTime dataConsulta;
  final TimeOfDay horarioAtual;
  final Function onSucesso;

  const TrocarHorarioForm({
    Key? key,
    required this.idConsulta,
    required this.idMedico,
    required this.dataConsulta,
    required this.horarioAtual,
    required this.onSucesso,
  }) : super(key: key);

  @override
  State<TrocarHorarioForm> createState() => _TrocarHorarioFormState();
}

class _TrocarHorarioFormState extends State<TrocarHorarioForm> {
  bool isLoading = true;
  List<TimeOfDay> horariosDisponiveis = [];
  TimeOfDay? horarioSelecionado;
  late int id_cliente;
  
  @override
  void initState() {
    super.initState();
    buscarCliente();
    _buscarHorariosDisponiveis();
  }

  void buscarCliente() {
    id_cliente =
    Provider.of<GerenciadorDeSessao>(context, listen: false).idUsuario!;
  }

  Future<void> _buscarHorariosDisponiveis() async {
    setState(() {
      isLoading = true;
    });

    try {
      var resposta = await HorariosDisponiveisMedicosService()
          .buscarHorariosPorIdMedico(widget.idMedico);

      if (resposta.Status == 200 && resposta.Dados != null) {
        List<TimeOfDay> tempHorariosDisponiveis = [];

        for (var horario in resposta.Dados!) {
          if (isSameDay(horario.data_real, widget.dataConsulta)) {
            tempHorariosDisponiveis.add(horario.horario);
          }
        }

        await _buscarConsultasExistentes(tempHorariosDisponiveis);
        
        if (tempHorariosDisponiveis.isEmpty) {
          _adicionarHorariosPadrao(tempHorariosDisponiveis);
        }
        
        setState(() {
          horariosDisponiveis = tempHorariosDisponiveis;
          isLoading = false;
        });
      } else {
        List<TimeOfDay> tempHorariosDisponiveis = [];
        _adicionarHorariosPadrao(tempHorariosDisponiveis);
        
        setState(() {
          horariosDisponiveis = tempHorariosDisponiveis;
          isLoading = false;
        });
      }
    } catch (e) {
      List<TimeOfDay> tempHorariosDisponiveis = [];
      _adicionarHorariosPadrao(tempHorariosDisponiveis);
      
      setState(() {
        horariosDisponiveis = tempHorariosDisponiveis;
        isLoading = false;
      });
    }
  }

  Future<void> _buscarConsultasExistentes(List<TimeOfDay> tempHorariosDisponiveis) async {
    try {
      var resposta = await ConsultaService().listarConsultas();

      if (resposta.Status == 200 && resposta.Dados != null) {
        for (var consulta in resposta.Dados!) {
          if (consulta.id == widget.idConsulta) continue;
          
          if (consulta.id_medico == widget.idMedico && isSameDay(consulta.data_consulta, widget.dataConsulta)) {
            TimeOfDay horarioConsulta = TimeOfDay(
              hour: consulta.data_consulta.hour,
              minute: consulta.data_consulta.minute,
            );
            
            tempHorariosDisponiveis.removeWhere(
              (horario) => horario.hour == horarioConsulta.hour && horario.minute == horarioConsulta.minute,
            );
          }
        }
      }
    } catch (e) {
    }
  }
  
  void _adicionarHorariosPadrao(List<TimeOfDay> tempHorariosDisponiveis) {
    tempHorariosDisponiveis.addAll([
      TimeOfDay(hour: 9, minute: 0),
      TimeOfDay(hour: 10, minute: 0),
      TimeOfDay(hour: 11, minute: 0),
      TimeOfDay(hour: 14, minute: 0),
      TimeOfDay(hour: 15, minute: 0),
      TimeOfDay(hour: 16, minute: 0),
    ]);
  }

  Future<void> _atualizarHorario() async {
    if (horarioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecione um horário para continuar")),
      );
      return;
    }

    if (horarioSelecionado!.hour == widget.horarioAtual.hour && 
        horarioSelecionado!.minute == widget.horarioAtual.minute) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Este já é o horário atual da consulta")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      DateTime novaDataHora = DateTime(
        widget.dataConsulta.year,
        widget.dataConsulta.month,
        widget.dataConsulta.day,
        horarioSelecionado!.hour,
        horarioSelecionado!.minute,
      );

      AtualizarConsultaDto atualizarConsultaDto = AtualizarConsultaDto(
        id: widget.idConsulta,
        data_consulta: novaDataHora,
        id_cliente: id_cliente,
        id_medico: widget.idMedico,
      );

      var resposta = await ConsultaService().atualizarConsulta(atualizarConsultaDto);

      setState(() {
        isLoading = false;
      });

      if (resposta.Status == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Horário alterado com sucesso")),
        );
        Navigator.pop(context);
        widget.onSucesso();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resposta.Mensagem ?? "Erro ao alterar horário")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao alterar horário: $e")),
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
          "Selecione o novo horário para sua consulta",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  children: [
                    Text(
                      "Data: ${widget.dataConsulta.day}/${widget.dataConsulta.month}/${widget.dataConsulta.year}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: horariosDisponiveis.map((TimeOfDay horario) {
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
                                  color: selecionado ? Color(0xFF585E97) : Color(0xFFE5E7FF),
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
                      ),
                    ),
                  ],
                ),
              ),
        SizedBox(height: 16),
        if (horarioSelecionado != null)
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.blue),
                SizedBox(width: 12),
                Text(
                  "${horarioSelecionado!.hour.toString().padLeft(2, '0')}:${horarioSelecionado!.minute.toString().padLeft(2, '0')}",
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
          onPressed: isLoading ? null : _atualizarHorario,
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
                  "Confirmar novo horário",
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
