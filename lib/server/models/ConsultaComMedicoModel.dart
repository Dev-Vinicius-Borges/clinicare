import 'package:clini_care/server/models/ConsultaModel.dart';
import 'package:clini_care/server/models/MedicoModel.dart';

class ConsultaComMedicoModel {
  ConsultaModel consulta;
  MedicoModel medico;

  ConsultaComMedicoModel({required this.consulta, required this.medico});
}
