import 'dart:io';

class CriarMedicoDto {
  String nome;
  String especialidade;
  String? foto_medico;
  File? fotoArquivo;

  CriarMedicoDto({
    required this.nome,
    required this.especialidade,
    this.foto_medico,
    this.fotoArquivo
  });
}