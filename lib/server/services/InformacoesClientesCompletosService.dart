import 'dart:io';

import 'package:clini_care/server/abstracts/IInformacoesClientesCompletoInterface.dart';
import 'package:clini_care/server/models/InformacoesClientesCompletoModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InformacoesClientesCompletosService
    implements IInformacoesClientesCompletosInterface {
  late SupabaseClient _contexto;

  InformacoesClientesCompletosService([SupabaseClient? informacoesClientes]) {
    _contexto = informacoesClientes ?? Supabase.instance.client;
  }

  @override
  Future<RespostaModel<InformacoesClientesCompletosModel>>
  buscarInformacoesClientePorId(int id) async {
    RespostaModel<InformacoesClientesCompletosModel> resposta =
        RespostaModel<InformacoesClientesCompletosModel>();

    try {
      var cliente =
          await _contexto
              .from('informacoes_clientes_completos')
              .select()
              .eq("id_cliente", id)
              .single();

      resposta.Dados = InformacoesClientesCompletosModel(
        id_cliente: cliente['id_cliente'],
        nome: cliente['nome'],
        email: cliente['email'],
        data_nascimento: DateTime.parse(cliente['data_nascimento']),
        senha: cliente['senha'],
        foto_cliente: cliente['foto_cliente'] ?? "",
        telefone_id: cliente['telefone_id'],
        telefone_numero: BigInt.parse(cliente['telefone_numero'].toString()),
        endereco_id: cliente['id_endereco'],
        cep: cliente['cep'],
        rua: cliente['rua'],
        numero: cliente['numero'],
        cidade: cliente['cidade'],
      );

      resposta.Mensagem = "Informações do cliente encontradas.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<List<InformacoesClientesCompletosModel>>>
  listarInformacoesClientes() async {
    RespostaModel<List<InformacoesClientesCompletosModel>> resposta =
        RespostaModel<List<InformacoesClientesCompletosModel>>();

    try {
      var clientes =
          await _contexto.from('informacoes_clientes_completos').select();

      resposta.Dados =
          clientes
              .map<InformacoesClientesCompletosModel>(
                (cliente) => InformacoesClientesCompletosModel(
                  id_cliente: cliente['id_cliente'],
                  nome: cliente['nome'],
                  email: cliente['email'],
                  data_nascimento: DateTime.parse(cliente['data_nascimento']),
                  senha: cliente['senha'],
                  foto_cliente: cliente['foto_cliente'] ?? "",
                  telefone_id: cliente['telefone_id'],
                  telefone_numero: BigInt.parse(
                    cliente['telefone_numero'].toString(),
                  ),
                  endereco_id: cliente['id_endereco'],
                  cep: cliente['cep'],
                  rua: cliente['rua'],
                  numero: cliente['numero'],
                  cidade: cliente['cidade'],
                ),
              )
              .toList();

      resposta.Mensagem = "Lista de clientes recuperada com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }
}
