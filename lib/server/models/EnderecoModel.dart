class EnderecoModel {
  int id;
  int cep;
  String rua;
  String numero;
  String cidade;

  EnderecoModel({
    required this.id,
    required this.cep,
    required this.rua,
    required this.numero,
    required this.cidade,
  });
}