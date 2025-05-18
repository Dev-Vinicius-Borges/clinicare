import 'package:clini_care/server/Dtos/endereco/AtualizarEndereoDto.dart';
import 'package:clini_care/server/Dtos/endereco/CriarEnderecoDto.dart';
import 'package:clini_care/server/models/EnderecoModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';

abstract class IEnderecoInterface {
  Future<RespostaModel<EnderecoModel>> criarEndereco(CriarEnderecoDto criarEnderecoDto);
  Future<RespostaModel<EnderecoModel>> buscarEnderecoPorId(int id);
  Future<RespostaModel<List<EnderecoModel>>> listarEnderecos();
  Future<RespostaModel<EnderecoModel>> atualizarEndereco(AtualizarEnderecoDto atualizarEnderecoDto);
  Future<RespostaModel<bool>> excluirEndereco(int id);
}