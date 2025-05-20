import 'dart:io';

import 'package:clini_care/server/models/ConsultaModel.dart';
import 'package:clini_care/server/models/MedicoModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';
import 'package:clini_care/server/services/MedicoService.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConsultaComMedicoModel {
  ConsultaModel consulta;
  MedicoModel medico;
  String horario;

  ConsultaComMedicoModel({
    required this.consulta,
    required this.medico,
    required this.horario,
  });
}

class ConsultaCompletoService {
  late SupabaseClient _contexto;
  late MedicoService _medicoService;

  ConsultaCompletoService([SupabaseClient? cliente]) {
    _contexto = cliente ?? Supabase.instance.client;
    _medicoService = MedicoService(_contexto);
  }

  Future<RespostaModel<List<ConsultaComMedicoModel>>>
  buscarConsultasComMedicoPorIdUsuario(int idUsuario) async {
    RespostaModel<List<ConsultaComMedicoModel>> resposta =
        RespostaModel<List<ConsultaComMedicoModel>>();

    try {
      var consultas = await _contexto
          .from('consultas')
          .select()
          .eq("fk_id_cliente", idUsuario);

      if (consultas.isEmpty) {
        resposta.Mensagem = "Nenhuma consulta encontrada.";
        resposta.Status = HttpStatus.notFound;
        resposta.Dados = [];
        return resposta;
      }

      List<ConsultaComMedicoModel> consultasCompletas = [];

      for (var consulta in consultas) {
        int idMedico = consulta['fk_id_medico'];

        var respostaMedico = await _medicoService.buscarMedicoPorId(idMedico);

        if (respostaMedico.Status == HttpStatus.ok &&
            respostaMedico.Dados != null) {
          ConsultaModel consultaModel = ConsultaModel(
            id: consulta['id_consulta'],
            data_consulta: DateTime.parse(consulta['data_consulta']),
            id_cliente: consulta['fk_id_cliente'],
            id_medico: consulta['fk_id_medico'],
          );

          String horario =
              "${consultaModel.data_consulta.hour.toString().padLeft(2, '0')}:${consultaModel.data_consulta.minute.toString().padLeft(2, '0')}";

          consultasCompletas.add(
            ConsultaComMedicoModel(
              consulta: consultaModel,
              medico: respostaMedico.Dados!,
              horario: horario,
            ),
          );
        }
      }

      resposta.Dados = consultasCompletas;
      resposta.Mensagem = "Consultas encontradas para o usuário.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
      resposta.Dados = [];
    }

    return resposta;
  }

  bool dataTemConsulta(DateTime data, List<ConsultaComMedicoModel> consultas) {
    return consultas.any(
      (consultaCompleta) =>
          consultaCompleta.consulta.data_consulta.year == data.year &&
          consultaCompleta.consulta.data_consulta.month == data.month &&
          consultaCompleta.consulta.data_consulta.day == data.day,
    );
  }

  List<ConsultaComMedicoModel> obterConsultasPorData(
    DateTime data,
    List<ConsultaComMedicoModel> consultas,
  ) {
    return consultas
        .where(
          (consultaCompleta) =>
              consultaCompleta.consulta.data_consulta.year == data.year &&
              consultaCompleta.consulta.data_consulta.month == data.month &&
              consultaCompleta.consulta.data_consulta.day == data.day,
        )
        .toList();
  }
}
