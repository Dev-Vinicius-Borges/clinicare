import 'dart:io';

class AtualizarClienteDto {
  int id;
  String nome;
  String email;
  DateTime data_nascimento;
  String senha;
  String foto_cliente;
  int telefone;
  int endereco;
  File? fotoArquivo;

  AtualizarClienteDto({
    required this.id,
    required this.nome,
    required this.email,
    required this.data_nascimento,
    required this.senha,
    required this.foto_cliente,
    required this.telefone,
    required this.endereco,
    this.fotoArquivo,
  });
}
