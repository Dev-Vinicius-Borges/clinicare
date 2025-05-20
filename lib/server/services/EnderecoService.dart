import 'dart:io';

import 'package:clini_care/server/Dtos/endereco/AtualizarEndereoDto.dart';
import 'package:clini_care/server/Dtos/endereco/CriarEnderecoDto.dart';
import 'package:clini_care/server/abstracts/IEnderecoInterface.dart';
import 'package:clini_care/server/models/EnderecoModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnderecoService implements IEnderecoInterface {
  late SupabaseClient _contexto;

  EnderecoService([SupabaseClient? endereco]) {
    _contexto = endereco ?? Supabase.instance.client;
  }

  @override
  Future<RespostaModel<EnderecoModel>> criarEndereco(
    CriarEnderecoDto criarEnderecoDto,
  ) async {
    RespostaModel<EnderecoModel> resposta = RespostaModel<EnderecoModel>();

    try {
      var novoEndereco =
          await _contexto
              .from('enderecos')
              .insert({
                "cep": criarEnderecoDto.cep,
                "rua": criarEnderecoDto.rua,
                "numero": criarEnderecoDto.numero,
                "cidade": criarEnderecoDto.cidade,
              })
              .select()
              .single();

      resposta.Dados = EnderecoModel(
        id: novoEndereco['id_endereco'],
        cep: novoEndereco['cep'],
        rua: novoEndereco['rua'],
        numero: novoEndereco['numero'],
        cidade: novoEndereco['cidade'],
      );

      resposta.Mensagem = "Endereço criado com sucesso.";
      resposta.Status = HttpStatus.created;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<EnderecoModel>> buscarEnderecoPorId(int id) async {
    RespostaModel<EnderecoModel> resposta = RespostaModel<EnderecoModel>();

    try {
      var endereco =
          await _contexto
              .from('enderecos')
              .select()
              .eq("id_endereco", id)
              .single();

      resposta.Dados = EnderecoModel(
        id: endereco['id_endereco'],
        cep: endereco['cep'],
        rua: endereco['rua'],
        numero: endereco['numero'],
        cidade: endereco['cidade'],
      );

      resposta.Mensagem = "Endereço encontrado.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<List<EnderecoModel>>> listarEnderecos() async {
    RespostaModel<List<EnderecoModel>> resposta =
        RespostaModel<List<EnderecoModel>>();

    try {
      var enderecos = await _contexto.from('enderecos').select();

      resposta.Dados =
          enderecos
              .map<EnderecoModel>(
                (endereco) => EnderecoModel(
                  id: endereco['id_endereco'],
                  cep: endereco['cep'],
                  rua: endereco['rua'],
                  numero: endereco['numero'],
                  cidade: endereco['cidade'],
                ),
              )
              .toList();

      resposta.Mensagem = "Lista de endereços recuperada com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<EnderecoModel>> atualizarEndereco(
    AtualizarEnderecoDto atualizarEnderecoDto,
  ) async {
    RespostaModel<EnderecoModel> resposta = RespostaModel<EnderecoModel>();

    try {
      var enderecoAtualizado =
          await _contexto
              .from('enderecos')
              .update({
                "cep": atualizarEnderecoDto.cep,
                "rua": atualizarEnderecoDto.rua,
                "numero": atualizarEnderecoDto.numero,
                "cidade": atualizarEnderecoDto.cidade,
              })
              .eq("id_endereco", atualizarEnderecoDto.id)
              .select()
              .single();

      resposta.Dados = EnderecoModel(
        id: enderecoAtualizado['id_endereco'],
        cep: enderecoAtualizado['cep'],
        rua: enderecoAtualizado['rua'],
        numero: enderecoAtualizado['numero'],
        cidade: enderecoAtualizado['cidade'],
      );

      resposta.Mensagem = "Endereço atualizado com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<bool>> excluirEndereco(int id) async {
    RespostaModel<bool> resposta = RespostaModel<bool>();

    try {
      await _contexto.from('enderecos').delete().eq("id_endereco", id);

      resposta.Dados = true;
      resposta.Mensagem = "Endereço excluído com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Dados = false;
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }
}
