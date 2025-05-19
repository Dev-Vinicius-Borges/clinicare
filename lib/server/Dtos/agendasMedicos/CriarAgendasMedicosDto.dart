class CriarAgendasMedicosDto {
  int fk_id_medico;
  String dia_semana;
  String horario;

  CriarAgendasMedicosDto({
    required this.fk_id_medico,
    required this.dia_semana,
    required this.horario,
  });
}
