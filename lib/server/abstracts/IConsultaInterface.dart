import 'package:clini_care/server/Dtos/consulta/AtualizarConsultaDto.dart';
import 'package:clini_care/server/Dtos/consulta/CriarConsultaDto.dart';
import 'package:clini_care/server/models/ConsultaModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';

abstract class IConsultaInterface {
  Future<RespostaModel<ConsultaModel>> criarConsulta(
    CriarConsultaDto criarConsultaDto,
  );

  Future<RespostaModel<ConsultaModel>> buscarConsultaPorId(int id);

  Future<RespostaModel<List<ConsultaModel>>> listarConsultas();

  Future<RespostaModel<List<ConsultaModel>>> buscarConsultaPorIdUsuario(int id);

  Future<RespostaModel<ConsultaModel>> atualizarConsulta(
    AtualizarConsultaDto atualizarConsultaDto,
  );

  Future<RespostaModel<bool>> excluirConsulta(int id);
}
