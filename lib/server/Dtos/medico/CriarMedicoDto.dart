class CriarMedicoDto {
  String nome;
  String especialidade;
  String? foto_medico;

  CriarMedicoDto({
    required this.nome,
    required this.especialidade,
    this.foto_medico,
  });
}