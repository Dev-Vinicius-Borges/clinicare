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
  DateTime dataInicial = DateTime.now();
  DateTime? dataSelecionada;
  late int id_usuario;
  bool isLoading = true;
  List<ConsultaComMedicoModel> consultasUsuario = [];
  final ConsultaCompletoService _consultaService = ConsultaCompletoService();

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
    } catch (e) {
      setState(() {
        consultasUsuario = [];
        isLoading = false;
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

  void trocarMedico(int idConsulta) {

  }

  void trocarHorario(int idConsulta) {

  }

  void trocarData(int idConsulta) {

  }

  @override
  void initState() {
    super.initState();
    buscarCliente();
    Future.delayed(Duration.zero, () {
      carregarConsultas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          locale: 'pt_BR',
          firstDay: DateTime.now(),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: DateTime.now(),
          selectedDayPredicate:
              (day) =>
                  dataSelecionada != null && isSameDay(dataSelecionada, day),
          onDaySelected: (selectedDay, focusedDay) {
            if (dataEstaDisponivel(selectedDay) || true) {
              setState(() {
                dataSelecionada = selectedDay;
                dataInicial = focusedDay;
              });
            }
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
          pageJumpingEnabled: false,
          availableCalendarFormats: const {CalendarFormat.week: 'Semana'},
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarFormat: CalendarFormat.week,
        ),
        Expanded(
          child:
              isLoading
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
