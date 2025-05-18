import 'package:clini_care/server/Dtos/telefone/AtualizarTelefoneDto.dart';
import 'package:clini_care/server/Dtos/telefone/CriarTelefoneDto.dart';
import 'package:clini_care/server/models/RespostaModel.dart';
import 'package:clini_care/server/models/TelefoneModel.dart';

abstract class ITelefoneInterface {
  Future<RespostaModel<TelefoneModel>> criarTelefone(CriarTelefoneDto criarTelefoneDto);
  Future<RespostaModel<TelefoneModel>> buscarTelefonePorId(int id);
  Future<RespostaModel<List<TelefoneModel>>> listarTelefones();
  Future<RespostaModel<TelefoneModel>> atualizarTelefone(AtualizarTelefoneDto atualizarTelefoneDto);
  Future<RespostaModel<bool>> excluirTelefone(int id);
}