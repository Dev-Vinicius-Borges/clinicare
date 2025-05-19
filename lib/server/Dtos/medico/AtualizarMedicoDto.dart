import 'dart:io';

class AtualizarMedicoDto {
  int id;
  String nome;
  String especialidade;
  String? foto_medico;
  File? fotoArquivo;

  AtualizarMedicoDto({
    required this.id,
    required this.nome,
    required this.especialidade,
    this.foto_medico,
    this.fotoArquivo,
  });
}
