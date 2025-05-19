import 'package:clini_care/server/Dtos/cliente/AtualizarClienteDto.dart';
import 'package:clini_care/server/Dtos/cliente/CriarClienteDto.dart';
import 'package:clini_care/server/Dtos/cliente/LoginDto.dart';
import 'package:clini_care/server/models/ClienteModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';

abstract class IClienteInterface {
  Future<RespostaModel<ClienteModel>> criarCliente(CriarClienteDto criarClienteDto);
  Future<RespostaModel<ClienteModel>> fazerLogin(LoginDto loginDt);
  Future<RespostaModel<ClienteModel>> buscarClientePorId(int id);
  Future<RespostaModel<ClienteModel>> buscarClientePorEmail(String email);
  Future<RespostaModel<List<ClienteModel>>> listarClientes();
  Future<RespostaModel<ClienteModel>> atualizarCliente(AtualizarClienteDto atualizarClienteDto);
  Future<RespostaModel<bool>> excluirCliente(int id);
}
