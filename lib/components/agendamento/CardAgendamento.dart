import 'package:flutter/material.dart';

class CardAgendamento extends StatefulWidget {
  final String horario;
  final String nome;
  final String especialidade;
  final String? fotoMedico;
  final int idConsulta;
  final Function? onCancelar;
  final Function? onTrocarMedico;
  final Function? onTrocarHorario;
  final Function? onTrocarData;

  const CardAgendamento({
    required this.horario,
    required this.nome,
    required this.especialidade,
    this.fotoMedico,
    required this.idConsulta,
    this.onCancelar,
    this.onTrocarMedico,
    this.onTrocarHorario,
    this.onTrocarData,
    super.key,
  });

  @override
  State<CardAgendamento> createState() => _CardAgendamentoState();
}

class _CardAgendamentoState extends State<CardAgendamento> {
  void _mostrarMenuOpcoes() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.blue),
                  title: Text('Trocar data'),
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.onTrocarData != null) {
                      widget.onTrocarData!();
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.access_time, color: Colors.blue),
                  title: Text('Trocar horário'),
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.onTrocarHorario != null) {
                      widget.onTrocarHorario!();
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person, color: Colors.blue),
                  title: Text('Trocar médico'),
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.onTrocarMedico != null) {
                      widget.onTrocarMedico!();
                    }
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.cancel, color: Colors.red),
                  title: Text(
                    'Cancelar consulta',
                    style: TextStyle(color: Colors.red),
                  ),
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

  void _confirmarCancelamento() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
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
                child: Text('Sim', style: TextStyle(color: Colors.red,fontSize: 18)),
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
        borderRadius: BorderRadius.circular(1000),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              width: 85,
              height: 85,
              child: Image.network(
                widget.fotoMedico!,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Icon(Icons.person, size: 100),
              ),
            ),
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
