class CriarEnderecoDto {
  int cep;
  String rua;
  String numero;
  String cidade;

  CriarEnderecoDto({
    required this.cep,
    required this.rua,
    required this.numero,
    required this.cidade,
  });
}