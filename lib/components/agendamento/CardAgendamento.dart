import 'package:flutter/material.dart';
import 'package:clini_care/components/BottomSheetContainer.dart';
import 'package:clini_care/components/TrocarMedicoForm.dart';
import 'package:clini_care/components/TrocarDataForm.dart';
import 'package:clini_care/components/TrocarHorarioForm.dart';

class CardAgendamento extends StatefulWidget {
  final String horario;
  final String nome;
  final String especialidade;
  final String? fotoMedico;
  final int idConsulta;
  final int idMedico;
  final DateTime dataConsulta;
  final TimeOfDay horaConsulta;
  final Function? onCancelar;
  final Function? onAtualizar;

  const CardAgendamento({
    required this.horario,
    required this.nome,
    required this.especialidade,
    this.fotoMedico,
    required this.idConsulta,
    required this.idMedico,
    required this.dataConsulta,
    required this.horaConsulta,
    this.onCancelar,
    this.onAtualizar,
    super.key,
  });

  @override
  State<CardAgendamento> createState() => _CardAgendamentoState();
}

class _CardAgendamentoState extends State<CardAgendamento> {
  void _mostrarMenuOpcoes() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.blue),
              title: Text('Trocar data'),
              onTap: () {
                Navigator.pop(context);
                _trocarData();
              },
            ),
            ListTile(
              leading: Icon(Icons.access_time, color: Colors.blue),
              title: Text('Trocar horário'),
              onTap: () {
                Navigator.pop(context);
                _trocarHorario();
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text('Trocar médico'),
              onTap: () {
                Navigator.pop(context);
                _trocarMedico();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.cancel, color: Colors.red),
              title: Text('Cancelar consulta', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmarCancelamento();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _trocarMedico() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetContainer(
        'Trocar médico',
        TrocarMedicoForm(
          idConsulta: widget.idConsulta,
          idMedicoAtual: widget.idMedico,
          onSucesso: () {
            if (widget.onAtualizar != null) {
              widget.onAtualizar!();
            }
          },
        ),
      ),
    );
  }

  void _trocarData() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetContainer(
        'Trocar data',
        TrocarDataForm(
          idConsulta: widget.idConsulta,
          idMedico: widget.idMedico,
          dataAtual: widget.dataConsulta,
          horarioAtual: widget.horaConsulta,
          onSucesso: () {
            if (widget.onAtualizar != null) {
              widget.onAtualizar!();
            }
          },
        ),
      ),
    );
  }

  void _trocarHorario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetContainer(
        'Trocar horário',
        TrocarHorarioForm(
          idConsulta: widget.idConsulta,
          idMedico: widget.idMedico,
          dataConsulta: widget.dataConsulta,
          horarioAtual: widget.horaConsulta,
          onSucesso: () {
            if (widget.onAtualizar != null) {
              widget.onAtualizar!();
            }
          },
        ),
      ),
    );
  }

  void _confirmarCancelamento() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancelar consulta'),
        content: Text('Tem certeza que deseja cancelar esta consulta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Não'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.onCancelar != null) {
                widget.onCancelar!();
              }
            },
            child: Text('Sim', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
            backgroundImage: widget.fotoMedico != null && widget.fotoMedico!.isNotEmpty
                ? NetworkImage(widget.fotoMedico!)
                : null,
            child: (widget.fotoMedico == null || widget.fotoMedico!.isEmpty)
                ? Icon(Icons.person, size: 30, color: Colors.grey[700])
                : null,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.horario,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  widget.nome,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.especialidade,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey[700]),
            onPressed: _mostrarMenuOpcoes,
          ),
        ],
      ),
    );
  }
}
