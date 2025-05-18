import 'dart:io';
import 'package:clini_care/server/Dtos/consulta/AtualizarConsultaDto.dart';
import 'package:clini_care/server/Dtos/consulta/CriarConsultaDto.dart';
import 'package:clini_care/server/abstracts/IConsultaInterface.dart';
import 'package:clini_care/server/models/ConsultaModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConsultaService implements IConsultaInterface {
  late SupabaseClient _contexto;

  ConsultaService([SupabaseClient? consulta]) {
    _contexto = consulta ?? Supabase.instance.client;
  }

  @override
  Future<RespostaModel<ConsultaModel>> criarConsulta(CriarConsultaDto criarConsultaDto) async {
    RespostaModel<ConsultaModel> resposta = RespostaModel<ConsultaModel>();

    try {
      var novaConsulta = await _contexto
          .from('consultas')
          .insert({
        "data_consulta": criarConsultaDto.data_consulta.toUtc().toIso8601String(),
        "fk_id_cliente": criarConsultaDto.id_cliente,
        "fk_id_medico": criarConsultaDto.id_medico,
      })
          .select()
          .single();

      resposta.Dados = ConsultaModel(
        id: novaConsulta['id_consulta'],
        data_consulta: DateTime.parse(novaConsulta['data_consulta']),
        id_cliente: novaConsulta['fk_id_cliente'],
        id_medico: novaConsulta['fk_id_medico'],
      );

      resposta.Mensagem = "Consulta agendada com sucesso.";
      resposta.Status = HttpStatus.created;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<ConsultaModel>> buscarConsultaPorId(int id) async {
    RespostaModel<ConsultaModel> resposta = RespostaModel<ConsultaModel>();

    try {
      var consulta = await _contexto.from('consultas').select().eq("id_consulta", id).single();

      resposta.Dados = ConsultaModel(
        id: consulta['id_consulta'],
        data_consulta: DateTime.parse(consulta['data_consulta']),
        id_cliente: consulta['fk_id_cliente'],
        id_medico: consulta['fk_id_medico'],
      );

      resposta.Mensagem = "Consulta encontrada.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<List<ConsultaModel>>> listarConsultas() async {
    RespostaModel<List<ConsultaModel>> resposta = RespostaModel<List<ConsultaModel>>();

    try {
      var consultas = await _contexto.from('consultas').select();

      resposta.Dados = consultas
          .map<ConsultaModel>((consulta) => ConsultaModel(
        id: consulta['id_consulta'],
        data_consulta: DateTime.parse(consulta['data_consulta']),
        id_cliente: consulta['fk_id_cliente'],
        id_medico: consulta['fk_id_medico'],
      ))
          .toList();

      resposta.Mensagem = "Lista de consultas recuperada com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<ConsultaModel>> atualizarConsulta(AtualizarConsultaDto atualizarConsultaDto) async {
    RespostaModel<ConsultaModel> resposta = RespostaModel<ConsultaModel>();

    try {
      var consultaAtualizada = await _contexto
          .from('consultas')
          .update({
        "data_consulta": atualizarConsultaDto.data_consulta.toUtc().toIso8601String(),
        "fk_id_cliente": atualizarConsultaDto.id_cliente,
        "fk_id_medico": atualizarConsultaDto.id_medico,
      })
          .eq("id_consulta", atualizarConsultaDto.id)
          .select()
          .single();

      resposta.Dados = ConsultaModel(
        id: consultaAtualizada['id_consulta'],
        data_consulta: DateTime.parse(consultaAtualizada['data_consulta']),
        id_cliente: consultaAtualizada['fk_id_cliente'],
        id_medico: consultaAtualizada['fk_id_medico'],
      );

      resposta.Mensagem = "Consulta atualizada com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<bool>> excluirConsulta(int id) async {
    RespostaModel<bool> resposta = RespostaModel<bool>();

    try {
      await _contexto.from('consultas').delete().eq("id_consulta", id);

      resposta.Dados = true;
      resposta.Mensagem = "Consulta excluída com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Dados = false;
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }
}
