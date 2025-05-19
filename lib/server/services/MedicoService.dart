import 'dart:io';
import 'package:clini_care/server/Dtos/medico/AtualizarMedicoDto.dart';
import 'package:clini_care/server/Dtos/medico/CriarMedicoDto.dart';
import 'package:clini_care/server/abstracts/IMedicoInterface.dart';
import 'package:clini_care/server/models/MedicoModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';
import 'package:clini_care/server/services/StorageService.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicoService implements IMedicoInterface {
  late SupabaseClient _contexto;

  MedicoService([SupabaseClient? medico]) {
    _contexto = medico ?? Supabase.instance.client;
  }

  @override
  Future<RespostaModel<MedicoModel>> criarMedico(
    CriarMedicoDto criarMedicoDto,
  ) async {
    RespostaModel<MedicoModel> resposta = RespostaModel<MedicoModel>();

    try {
      String? fotoUrl;
      if (criarMedicoDto.fotoArquivo != null) {
        fotoUrl = await StorageService().uploadImagem(
          criarMedicoDto.fotoArquivo!,
          "profissional_${criarMedicoDto.nome}.jpg",
          "profissionais",
        );
      }

      var novoMedico =
          await _contexto
              .from('medicos')
              .insert({
                "nome_medico": criarMedicoDto.nome,
                "especialidade": criarMedicoDto.especialidade,
                "foto_medico": fotoUrl ?? "",
              })
              .select()
              .single();

      resposta.Dados = MedicoModel(
        id: novoMedico['id_medico'],
        nome: novoMedico['nome_medico'],
        especialidade: novoMedico['especialidade'],
        foto_medico: fotoUrl ?? "",
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
      var medico =
          await _contexto.from('medicos').select().eq("id_medico", id).single();
      String fotoUrl = StorageService().getImagemUrl(
        "profissional_${medico['nome_medico']}.jpg",
        "profissionais",
      );

      resposta.Dados = MedicoModel(
        id: medico['id_medico'],
        nome: medico['nome_medico'],
        especialidade: medico['especialidade'],
        foto_medico: fotoUrl,
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
  Future<List<Map<String, dynamic>>> buscarListaProfissionais() async {
    try {
      var medicos = await _contexto.from('medicos').select();

      return medicos.map<Map<String, dynamic>>((medico) {
        List<String> partesNome = medico['nome_medico'].split(" ");
        String nomeArquivo =
            partesNome.length > 1
                ? "${partesNome[0]}_${partesNome[1]}"
                : partesNome[0];

        String fotoUrl = StorageService().getImagemUrl(
          "profissional_${nomeArquivo}.jpg",
          "profissionais",
        );

        return {
          'id': medico['id_medico'],
          'nome': medico['nome_medico'],
          'especialidade': medico['especialidade'],
          'foto': fotoUrl,
        };
      }).toList();
    } catch (err) {
      print("Erro: $err");
      return [];
    }
  }

  @override
  Future<RespostaModel<MedicoModel>> atualizarMedico(
    AtualizarMedicoDto atualizarMedicoDto,
  ) async {
    RespostaModel<MedicoModel> resposta = RespostaModel<MedicoModel>();

    try {
      String? fotoUrl;
      if (atualizarMedicoDto.fotoArquivo != null) {
        fotoUrl = await StorageService().atualizarImagem(
          atualizarMedicoDto.fotoArquivo!,
          "profissional_${atualizarMedicoDto.nome}.jpg",
          "profissionais",
        );
      }

      var medicoAtualizado =
          await _contexto
              .from('medicos')
              .update({
                "nome_medico": atualizarMedicoDto.nome,
                "especialidade": atualizarMedicoDto.especialidade,
                "foto_medico": fotoUrl ?? atualizarMedicoDto.foto_medico,
              })
              .eq("id_medico", atualizarMedicoDto.id)
              .select()
              .single();

      resposta.Dados = MedicoModel(
        id: medicoAtualizado['id_medico'],
        nome: medicoAtualizado['nome_medico'],
        especialidade: medicoAtualizado['especialidade'],
        foto_medico: fotoUrl ?? medicoAtualizado['foto_medico'] ?? "",
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
      var medico =
          await _contexto
              .from('medicos')
              .select("nome_medico")
              .eq("id_medico", id)
              .single();

      await _contexto.from('medicos').delete().eq("id_medico", id);
      await StorageService().deletarImagem(
        "profissional_${medico['nome_medico']}.jpg",
        "profissionais",
      );

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
