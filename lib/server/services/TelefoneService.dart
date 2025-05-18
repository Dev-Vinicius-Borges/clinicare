import 'dart:io';
import 'package:clini_care/server/Dtos/telefone/AtualizarTelefoneDto.dart';
import 'package:clini_care/server/Dtos/telefone/CriarTelefoneDto.dart';
import 'package:clini_care/server/abstracts/ITelefoneInterface.dart';
import 'package:clini_care/server/models/RespostaModel.dart';
import 'package:clini_care/server/models/TelefoneModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelefoneService implements ITelefoneInterface {
  late SupabaseClient _contexto;

  TelefoneService([SupabaseClient? telefone]) {
    _contexto = telefone ?? Supabase.instance.client;
  }

  @override
  Future<RespostaModel<TelefoneModel>> criarTelefone(CriarTelefoneDto criarTelefoneDto) async {
    RespostaModel<TelefoneModel> resposta = RespostaModel<TelefoneModel>();

    try {
      var novoTelefone = await _contexto
          .from('telefones')
          .insert({
        "numero": criarTelefoneDto.numero,
      })
          .select()
          .single();

      resposta.Dados = TelefoneModel(
        id: novoTelefone['id_telefone'],
        numero: BigInt.parse(novoTelefone['numero'].toString()),
      );

      resposta.Mensagem = "Telefone cadastrado com sucesso.";
      resposta.Status = HttpStatus.created;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<TelefoneModel>> buscarTelefonePorId(int id) async {
    RespostaModel<TelefoneModel> resposta = RespostaModel<TelefoneModel>();

    try {
      var telefone = await _contexto.from('telefones').select().eq("id_telefone", id).single();

      resposta.Dados = TelefoneModel(
        id: telefone['id_telefone'],
        numero: BigInt.parse(telefone['numero'].toString()),
      );

      resposta.Mensagem = "Telefone encontrado.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<List<TelefoneModel>>> listarTelefones() async {
    RespostaModel<List<TelefoneModel>> resposta = RespostaModel<List<TelefoneModel>>();

    try {
      var telefones = await _contexto.from('telefones').select();

      resposta.Dados = telefones
          .map<TelefoneModel>((telefone) => TelefoneModel(
        id: telefone['id_telefone'],
        numero: BigInt.parse(telefone['numero'].toString()),
      ))
          .toList();

      resposta.Mensagem = "Lista de telefones recuperada com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<TelefoneModel>> atualizarTelefone(AtualizarTelefoneDto atualizarTelefoneDto) async {
    RespostaModel<TelefoneModel> resposta = RespostaModel<TelefoneModel>();

    try {
      var telefoneAtualizado = await _contexto
          .from('telefones')
          .update({
        "numero": atualizarTelefoneDto.numero,
      })
          .eq("id_telefone", atualizarTelefoneDto.id)
          .select()
          .single();

      resposta.Dados = TelefoneModel(
        id: telefoneAtualizado['id_telefone'],
        numero: BigInt.parse(telefoneAtualizado['numero'].toString()),
      );

      resposta.Mensagem = "Telefone atualizado com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<bool>> excluirTelefone(int id) async {
    RespostaModel<bool> resposta = RespostaModel<bool>();

    try {
      await _contexto.from('telefones').delete().eq("id_telefone", id);

      resposta.Dados = true;
      resposta.Mensagem = "Telefone excluído com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Dados = false;
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }
}
