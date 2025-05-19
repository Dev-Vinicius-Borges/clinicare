import 'package:clini_care/server/Dtos/medico/AtualizarMedicoDto.dart';
import 'package:clini_care/server/Dtos/medico/CriarMedicoDto.dart';
import 'package:clini_care/server/models/MedicoModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';

abstract class IMedicoInterface {
  Future<RespostaModel<MedicoModel>> criarMedico(CriarMedicoDto criarMedicoDto);
  Future<RespostaModel<MedicoModel>> buscarMedicoPorId(int id);
  Future<List<Map<String, dynamic>>> buscarListaProfissionais();
  Future<RespostaModel<MedicoModel>> atualizarMedico(AtualizarMedicoDto atualizarMedicoDto);
  Future<RespostaModel<bool>> excluirMedico(int id);
}