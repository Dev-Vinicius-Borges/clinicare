class InformacoesClientesCompletosModel {
  int id_cliente;
  String nome;
  String email;
  DateTime data_nascimento;
  String senha;
  String foto_cliente;
  int telefone_id;
  BigInt telefone_numero;
  int endereco_id;
  int cep;
  String rua;
  String numero;
  String cidade;

  InformacoesClientesCompletosModel({
    required this.id_cliente,
    required this.nome,
    required this.email,
    required this.data_nascimento,
    required this.senha,
    required this.foto_cliente,
    required this.telefone_id,
    required this.telefone_numero,
    required this.endereco_id,
    required this.cep,
    required this.rua,
    required this.numero,
    required this.cidade,
  });
}
