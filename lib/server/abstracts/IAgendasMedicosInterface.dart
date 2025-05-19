import 'package:clini_care/server/Dtos/agendasMedicos/AtualizarAgendasMedicosDto.dart';
import 'package:clini_care/server/Dtos/agendasMedicos/CriarAgendasMedicosDto.dart';
import 'package:clini_care/server/models/AgendasMedicosModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';

abstract class IAgendasMedicosInterface {
  Future<RespostaModel<AgendasMedicosModel>> criarAgenda(
    CriarAgendasMedicosDto criarAgendaDto,
  );

  Future<RespostaModel<AgendasMedicosModel>> buscarAgendaPorId(int id);

  Future<RespostaModel<List<AgendasMedicosModel>>> listarAgendas();

  Future<RespostaModel<AgendasMedicosModel>> atualizarAgenda(
    AtualizarAgendasMedicosDto atualizarAgendaDto,
  );

  Future<RespostaModel<bool>> excluirAgenda(int id);
}
