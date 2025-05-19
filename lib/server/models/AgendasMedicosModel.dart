import 'package:flutter/material.dart';

class AgendasMedicosModel {
  int id_agenda;
  int fk_id_medico;
  String dia_semana;
  TimeOfDay horario;

  AgendasMedicosModel({
    required this.id_agenda,
    required this.fk_id_medico,
    required this.dia_semana,
    required this.horario,
  });
}
