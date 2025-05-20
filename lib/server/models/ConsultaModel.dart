class ConsultaModel {
  int id;
  DateTime data_consulta;
  int id_cliente;
  int id_medico;

  ConsultaModel({
    required this.id,
    required this.data_consulta,
    required this.id_cliente,
    required this.id_medico,
  });
}
