import 'package:flutter/material.dart';

class ConfirmarAgendamento extends StatefulWidget {
  final int id_profissional;
  final String especialidade;
  final DateTime data_consulta;
  final int hora_consulta;

  ConfirmarAgendamento(
    this.id_profissional,
    this.especialidade,
    this.data_consulta,
    this.hora_consulta,
  );

  @override
  State<ConfirmarAgendamento> createState() => _ConfirmarAgendamentoState();
}

class _ConfirmarAgendamentoState extends State<ConfirmarAgendamento> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(
                  'assets/doctor.jpg',
                ), // ou NetworkImage
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nome do médico",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text("Especialidade", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          // Data
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16),
                  SizedBox(width: 4),
                  Text("Data"),
                ],
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.edit, size: 14),
                label: Text("Editar"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  textStyle: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 22.0),
              child: Text(
                "31/03/2025",
                style: TextStyle(fontSize: 13, color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 10),
          // Horário
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, size: 16),
                  SizedBox(width: 4),
                  Text("Horário"),
                ],
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.edit, size: 14),
                label: Text("Editar"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  textStyle: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 22.0),
              child: Text(
                "14:00",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 10),
          // Checkbox
          Row(
            children: [
              Icon(Icons.radio_button_checked, color: Colors.blue, size: 16),
              SizedBox(width: 6),
              Expanded(child: Text("Desejo receber uma confirmação por SMS.")),
            ],
          ),
          SizedBox(height: 20),
          // Botões
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Agendar consulta"),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Cancelar"),
          ),
        ],
      ),
    );
  }
}
