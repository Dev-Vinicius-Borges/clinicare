class CriarConsultaDto {
  DateTime data_consulta;
  int id_cliente;
  int id_medico;

  CriarConsultaDto({
    required this.data_consulta,
    required this.id_cliente,
    required this.id_medico,
  });
}
