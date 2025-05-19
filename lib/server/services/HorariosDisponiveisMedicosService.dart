import 'dart:io';
import 'package:clini_care/server/abstracts/IHorariosDisponiveisMedicosInterface.dart';
import 'package:clini_care/server/models/HorariosDisponiveisMedicosModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HorariosDisponiveisMedicosService implements IHorariosDisponiveisMedicosInterface {
  late SupabaseClient _contexto;

  HorariosDisponiveisMedicosService([SupabaseClient? horariosDisponiveis]) {
    _contexto = horariosDisponiveis ?? Supabase.instance.client;
  }

  @override
  Future<RespostaModel<List<HorariosDisponiveisMedicosModel>>> buscarHorariosPorIdMedico(int id_medico) async {
    RespostaModel<List<HorariosDisponiveisMedicosModel>> resposta = RespostaModel<List<HorariosDisponiveisMedicosModel>>();

    try {
      var horarios = await _contexto
          .from('horarios_disponiveis_medicos')
          .select()
          .eq("id_medico", id_medico);

      resposta.Dados = horarios.map<HorariosDisponiveisMedicosModel>((horario) => HorariosDisponiveisMedicosModel(
        id_medico: horario['id_medico'],
        nome_medico: horario['nome_medico'],
        dia_semana: horario['dia_semana'],
        horario: TimeOfDay(
          hour: int.parse(horario['horario'].split(':')[0]),
          minute: int.parse(horario['horario'].split(':')[1]),
        ),
      )).toList();

      resposta.Mensagem = "Horários encontrados com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }


  @override
  Future<RespostaModel<List<HorariosDisponiveisMedicosModel>>> listarHorariosDisponiveis() async {
    RespostaModel<List<HorariosDisponiveisMedicosModel>> resposta = RespostaModel<List<HorariosDisponiveisMedicosModel>>();

    try {
      var horarios = await _contexto.from('horarios_disponiveis_medicos').select();

      resposta.Dados = horarios.map<HorariosDisponiveisMedicosModel>((horario) => HorariosDisponiveisMedicosModel(
        id_medico: horario['id_medico'],
        nome_medico: horario['nome_medico'],
        dia_semana: horario['dia_semana'],
        horario: TimeOfDay(
          hour: int.parse(horario['horario'].split(':')[0]),
          minute: int.parse(horario['horario'].split(':')[1]),
        ),
      )).toList();

      resposta.Mensagem = "Lista de horários recuperada com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }
}
