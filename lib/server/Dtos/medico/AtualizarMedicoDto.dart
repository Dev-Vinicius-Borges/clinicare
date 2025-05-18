class AtualizarMedicoDto {
  int id;
  String nome;
  String especialidade;
  String? foto_medico;

  AtualizarMedicoDto({
    required this.id,
    required this.nome,
    required this.especialidade,
    this.foto_medico,
  });
}