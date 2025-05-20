import 'dart:io';

import 'package:clini_care/server/Dtos/agendasMedicos/AtualizarAgendasMedicosDto.dart';
import 'package:clini_care/server/Dtos/agendasMedicos/CriarAgendasMedicosDto.dart';
import 'package:clini_care/server/abstracts/IAgendasMedicosInterface.dart';
import 'package:clini_care/server/models/AgendasMedicosModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AgendasMedicosService implements IAgendasMedicosInterface {
  late SupabaseClient _contexto;

  AgendasMedicosService([SupabaseClient? agendasMedicos]) {
    _contexto = agendasMedicos ?? Supabase.instance.client;
  }

  @override
  Future<RespostaModel<AgendasMedicosModel>> buscarAgendaPorId(int id) async {
    RespostaModel<AgendasMedicosModel> resposta =
        RespostaModel<AgendasMedicosModel>();

    try {
      var agenda =
          await _contexto
              .from('agendas_medicos')
              .select()
              .eq("id_agenda", id)
              .single();

      resposta.Dados = AgendasMedicosModel(
        id_agenda: agenda['id_agenda'],
        fk_id_medico: agenda['fk_id_medico'],
        dia_semana: agenda['dia_semana'],
        horario: TimeOfDay(
          hour: int.parse(agenda['horario'].split(':')[0]),
          minute: int.parse(agenda['horario'].split(':')[1]),
        ),
      );

      resposta.Mensagem = "Agenda encontrada com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<List<AgendasMedicosModel>>> listarAgendas() async {
    RespostaModel<List<AgendasMedicosModel>> resposta =
        RespostaModel<List<AgendasMedicosModel>>();

    try {
      var agendas = await _contexto.from('agendas_medicos').select();

      resposta.Dados =
          agendas
              .map<AgendasMedicosModel>(
                (agenda) => AgendasMedicosModel(
                  id_agenda: agenda['id_agenda'],
                  fk_id_medico: agenda['fk_id_medico'],
                  dia_semana: agenda['dia_semana'],
                  horario: TimeOfDay(
                    hour: int.parse(agenda['horario'].split(':')[0]),
                    minute: int.parse(agenda['horario'].split(':')[1]),
                  ),
                ),
              )
              .toList();

      resposta.Mensagem = "Lista de agendas recuperada com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<AgendasMedicosModel>> atualizarAgenda(
    AtualizarAgendasMedicosDto atualizarAgendaDto,
  ) async {
    RespostaModel<AgendasMedicosModel> resposta =
        RespostaModel<AgendasMedicosModel>();

    try {
      var agendaAtualizada =
          await _contexto
              .from('agendas_medicos')
              .update({
                "fk_id_medico": atualizarAgendaDto.fk_id_medico,
                "dia_semana": atualizarAgendaDto.dia_semana,
                "horario": atualizarAgendaDto.horario,
              })
              .eq("id_agenda", atualizarAgendaDto.id_agenda)
              .select()
              .single();

      resposta.Dados = AgendasMedicosModel(
        id_agenda: agendaAtualizada['id_agenda'],
        fk_id_medico: agendaAtualizada['fk_id_medico'],
        dia_semana: agendaAtualizada['dia_semana'],
        horario: TimeOfDay(
          hour: int.parse(agendaAtualizada['horario'].split(':')[0]),
          minute: int.parse(agendaAtualizada['horario'].split(':')[1]),
        ),
      );

      resposta.Mensagem = "Agenda atualizada com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<AgendasMedicosModel>> criarAgenda(
    CriarAgendasMedicosDto criarAgendaDto,
  ) async {
    RespostaModel<AgendasMedicosModel> resposta =
        RespostaModel<AgendasMedicosModel>();

    try {
      var novaAgenda =
          await _contexto
              .from('agendas_medicos')
              .insert({
                "fk_id_medico": criarAgendaDto.fk_id_medico,
                "dia_semana": criarAgendaDto.dia_semana,
                "horario": criarAgendaDto.horario,
              })
              .select()
              .single();

      resposta.Dados = AgendasMedicosModel(
        id_agenda: novaAgenda['id_agenda'],
        fk_id_medico: novaAgenda['fk_id_medico'],
        dia_semana: novaAgenda['dia_semana'],
        horario: TimeOfDay(
          hour: int.parse(novaAgenda['horario'].split(':')[0]),
          minute: int.parse(novaAgenda['horario'].split(':')[1]),
        ),
      );

      resposta.Mensagem = "Agenda criada com sucesso.";
      resposta.Status = HttpStatus.created;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<bool>> excluirAgenda(int id) async {
    RespostaModel<bool> resposta = RespostaModel<bool>();

    try {
      await _contexto.from('agendas_medicos').delete().eq("id_agenda", id);

      resposta.Dados = true;
      resposta.Mensagem = "Agenda excluída com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Dados = false;
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }
}
