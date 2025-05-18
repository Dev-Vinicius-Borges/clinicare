import 'dart:io';
import 'package:clini_care/server/Dtos/medico/AtualizarMedicoDto.dart';
import 'package:clini_care/server/Dtos/medico/CriarMedicoDto.dart';
import 'package:clini_care/server/abstracts/IMedicoInterface.dart';
import 'package:clini_care/server/models/MedicoModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicoService implements IMedicoInterface {
  late SupabaseClient _contexto;

  MedicoService([SupabaseClient? medico]) {
    _contexto = medico ?? Supabase.instance.client;
  }

  @override
  Future<RespostaModel<MedicoModel>> criarMedico(CriarMedicoDto criarMedicoDto) async {
    RespostaModel<MedicoModel> resposta = RespostaModel<MedicoModel>();

    try {
      var novoMedico = await _contexto
          .from('medicos')
          .insert({
        "nome_medico": criarMedicoDto.nome,
        "especialidade": criarMedicoDto.especialidade,
        "foto_medico": criarMedicoDto.foto_medico,
      })
          .select()
          .single();

      resposta.Dados = MedicoModel(
        id: novoMedico['id_medico'],
        nome: novoMedico['nome_medico'],
        especialidade: novoMedico['especialidade'],
        foto_medico: novoMedico['foto_medico'] ?? "",
      );

      resposta.Mensagem = "Médico cadastrado com sucesso.";
      resposta.Status = HttpStatus.created;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<MedicoModel>> buscarMedicoPorId(int id) async {
    RespostaModel<MedicoModel> resposta = RespostaModel<MedicoModel>();

    try {
      var medico = await _contexto.from('medicos').select().eq("id_medico", id).single();

      resposta.Dados = MedicoModel(
        id: medico['id_medico'],
        nome: medico['nome_medico'],
        especialidade: medico['especialidade'],
        foto_medico: medico['foto_medico'] ?? "",
      );

      resposta.Mensagem = "Médico encontrado.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<List<MedicoModel>>> listarMedicos() async {
    RespostaModel<List<MedicoModel>> resposta = RespostaModel<List<MedicoModel>>();

    try {
      var medicos = await _contexto.from('medicos').select();

      resposta.Dados = medicos
          .map<MedicoModel>((medico) => MedicoModel(
        id: medico['id_medico'],
        nome: medico['nome_medico'],
        especialidade: medico['especialidade'],
        foto_medico: medico['foto_medico'] ?? "",
      ))
          .toList();

      resposta.Mensagem = "Lista de médicos recuperada com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<MedicoModel>> atualizarMedico(AtualizarMedicoDto atualizarMedicoDto) async {
    RespostaModel<MedicoModel> resposta = RespostaModel<MedicoModel>();

    try {
      var medicoAtualizado = await _contexto
          .from('medicos')
          .update({
        "nome_medico": atualizarMedicoDto.nome,
        "especialidade": atualizarMedicoDto.especialidade,
        "foto_medico": atualizarMedicoDto.foto_medico,
      })
          .eq("id_medico", atualizarMedicoDto.id)
          .select()
          .single();

      resposta.Dados = MedicoModel(
        id: medicoAtualizado['id_medico'],
        nome: medicoAtualizado['nome_medico'],
        especialidade: medicoAtualizado['especialidade'],
        foto_medico: medicoAtualizado['foto_medico'] ?? "",
      );

      resposta.Mensagem = "Médico atualizado com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<bool>> excluirMedico(int id) async {
    RespostaModel<bool> resposta = RespostaModel<bool>();

    try {
      await _contexto.from('medicos').delete().eq("id_medico", id);

      resposta.Dados = true;
      resposta.Mensagem = "Médico excluído com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Dados = false;
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }
}
