import 'package:clini_care/components/agendamento/CardAgendamento.dart';
import 'package:clini_care/components/agendamento/CardSemConsulta.dart';
import 'package:clini_care/server/services/ConsultaCompletoService.dart';
import 'package:clini_care/server/services/ConsultaService.dart';
import 'package:clini_care/server/session/configuracao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendamentoFeitos extends StatefulWidget {
  @override
  _AgendamentoFeitosState createState() => _AgendamentoFeitosState();
}

class _AgendamentoFeitosState extends State<AgendamentoFeitos> {
  DateTime _focusedDay = DateTime.now();
  DateTime? dataSelecionada;
  late int id_usuario;
  bool isLoading = true;
  List<ConsultaComMedicoModel> consultasUsuario = [];
  final ConsultaCompletoService _consultaService = ConsultaCompletoService();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  bool dataEstaDisponivel(DateTime day) {
    return _consultaService.dataTemConsulta(day, consultasUsuario);
  }

  List<ConsultaComMedicoModel> obterAgendamentos(DateTime? data) {
    return data != null
        ? _consultaService.obterConsultasPorData(data, consultasUsuario)
        : [];
  }

  void buscarCliente() {
    id_usuario =
        Provider.of<GerenciadorDeSessao>(context, listen: false).idUsuario!;
  }

  Future<void> carregarConsultas() async {
    setState(() {
      isLoading = true;
    });

    try {
      var resposta = await _consultaService
          .buscarConsultasComMedicoPorIdUsuario(id_usuario);

      setState(() {
        consultasUsuario = resposta.Dados ?? [];
        isLoading = false;
      });
      
      _focarDataMaisProximaComConsulta();
    } catch (e) {
      setState(() {
        consultasUsuario = [];
        isLoading = false;
      });
    }
  }
  
  void _focarDataMaisProximaComConsulta() {
    if (consultasUsuario.isEmpty) return;
    
    consultasUsuario.sort((a, b) =>
      a.consulta.data_consulta.compareTo(b.consulta.data_consulta));
    
    DateTime agora = DateTime.now();
    DateTime? proximaData;
    
    for (var consulta in consultasUsuario) {
      DateTime dataConsulta = consulta.consulta.data_consulta;
      DateTime dataNormalizada = DateTime(
        dataConsulta.year,
        dataConsulta.month,
        dataConsulta.day,
      );
      
      if (dataNormalizada.isAfter(agora) || isSameDay(dataNormalizada, agora)) {
        proximaData = dataNormalizada;
        break;
      }
    }
    
    if (proximaData == null && consultasUsuario.isNotEmpty) {
      var ultimaConsulta = consultasUsuario.last;
      proximaData = DateTime(
        ultimaConsulta.consulta.data_consulta.year,
        ultimaConsulta.consulta.data_consulta.month,
        ultimaConsulta.consulta.data_consulta.day,
      );
    }
    
    if (proximaData != null) {
      setState(() {
        dataSelecionada = proximaData;
        _focusedDay = proximaData!;
      });
    }
  }

  Future<void> cancelarConsulta(int idConsulta) async {
    setState(() {
      isLoading = true;
    });

    try {
      var resposta = await ConsultaService().excluirConsulta(idConsulta);

      if (resposta.Status == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Consulta cancelada com sucesso")),
        );
        await carregarConsultas();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao cancelar consulta: ${resposta.Mensagem}"),
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao cancelar consulta: $e")));
      setState(() {
        isLoading = false;
      });
    }
  }

  void trocarMedico(int idConsulta) {}

  void trocarHorario(int idConsulta) {}

  void trocarData(int idConsulta) {}

  @override
  void initState() {
    super.initState();
    buscarCliente();
    Future.delayed(Duration.zero, () {
      carregarConsultas();
    });
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          locale: 'pt_BR',
          firstDay: DateTime.now().subtract(Duration(days: 365)),
          lastDay: DateTime.now().add(Duration(days: 365)),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) =>
              dataSelecionada != null && isSameDay(dataSelecionada!, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              dataSelecionada = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: CalendarStyle(
            defaultDecoration: BoxDecoration(shape: BoxShape.circle),
            todayDecoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
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
          headerVisible: true,
          daysOfWeekVisible: true,
          pageJumpingEnabled: true,
          availableCalendarFormats: const {
            CalendarFormat.week: 'Semana',
            CalendarFormat.month: 'Mês'
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
        ),
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : dataSelecionada == null
                  ? Center(
                      child: Text('Selecione uma data para ver as consultas'),
                    )
                  : Builder(
                      builder: (context) {
                        final agendamentosDoDia = obterAgendamentos(
                          dataSelecionada,
                        );

                        if (agendamentosDoDia.isEmpty) {
                          return CardSemConsulta();
                        }

                        return ListView.builder(
                          itemCount: agendamentosDoDia.length,
                          itemBuilder: (context, index) {
                            var agendamento = agendamentosDoDia[index];

                            String horarioFormatado =
                                '${agendamento.consulta.data_consulta.hour.toString().padLeft(2, '0')}:${agendamento.consulta.data_consulta.minute.toString().padLeft(2, '0')}';

                            return CardAgendamento(
                              idMedico: agendamento.medico.id,
                              dataConsulta: agendamento.consulta.data_consulta,
                              horaConsulta: TimeOfDay(
                                hour: agendamento.consulta.data_consulta.hour,
                                minute: agendamento.consulta.data_consulta.minute,
                              ),
                              horario: horarioFormatado,
                              nome: agendamento.medico.nome,
                              especialidade: agendamento.medico.especialidade,
                              fotoMedico: agendamento.medico.foto_medico,
                              idConsulta: agendamento.consulta.id,
                              onCancelar:
                                  () => cancelarConsulta(agendamento.consulta.id),
                              onTrocarMedico:
                                  () => trocarMedico(agendamento.consulta.id),
                              onTrocarHorario:
                                  () => trocarHorario(agendamento.consulta.id),
                              onTrocarData:
                                  () => trocarData(agendamento.consulta.id),
                            );
                          },
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
