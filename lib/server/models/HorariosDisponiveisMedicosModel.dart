import 'package:flutter/material.dart';

class HorariosDisponiveisMedicosModel {
  int id_medico;
  String nome_medico;
  String dia_semana;
  TimeOfDay horario;

  HorariosDisponiveisMedicosModel({
    required this.id_medico,
    required this.nome_medico,
    required this.dia_semana,
    required this.horario,
  });
}
