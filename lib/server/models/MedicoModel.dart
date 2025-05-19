import 'dart:io';

class MedicoModel {
  int id;
  String nome;
  String especialidade;
  String? foto_medico;
  File? fotoArquivo;

  MedicoModel({
    required this.id,
    required this.nome,
    required this.especialidade,
    this.foto_medico,
    this.fotoArquivo,
  });
}
