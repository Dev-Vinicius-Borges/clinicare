import 'package:clini_care/server/models/InformacoesClientesCompletoModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';

abstract class IInformacoesClientesCompletosInterface {
  Future<RespostaModel<InformacoesClientesCompletosModel>> buscarInformacoesClientePorId(int id);
  Future<RespostaModel<List<InformacoesClientesCompletosModel>>> listarInformacoesClientes();
}