import 'package:flutter/material.dart';

class HorariosDisponiveisMedicosModel {
  int id_agenda;
  int id_medico;
  String nome_medico;
  String foto_medico;
  String especialidade;
  DateTime data_real;
  TimeOfDay horario;

  HorariosDisponiveisMedicosModel({
    required this.id_agenda,
    required this.id_medico,
    required this.nome_medico,
    required this.foto_medico,
    required this.especialidade,
    required this.data_real,
    required this.horario,
  });
}
