import 'package:clini_care/server/models/HorariosDisponiveisMedicosModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';

abstract class IHorariosDisponiveisMedicosInterface {
  Future<RespostaModel<List<HorariosDisponiveisMedicosModel>>>
  listarHorariosDisponiveis();

  Future<RespostaModel<List<HorariosDisponiveisMedicosModel>>>buscarHorariosPorIdMedico(int id_medico);
}
