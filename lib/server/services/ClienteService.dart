import 'dart:io';
import 'package:clini_care/server/Dtos/cliente/AtualizarClienteDto.dart';
import 'package:clini_care/server/Dtos/cliente/CriarClienteDto.dart';
import 'package:clini_care/server/Dtos/cliente/LoginDto.dart';
import 'package:clini_care/server/abstracts/IClienteInterface.dart';
import 'package:clini_care/server/models/ClienteModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClienteService implements IClienteInterface {
  late SupabaseClient _contexto;

  ClienteService([SupabaseClient? cliente]) {
    _contexto = cliente ?? Supabase.instance.client;
  }

  @override
  Future<RespostaModel<ClienteModel>> atualizarCliente(
    AtualizarClienteDto atualizarClienteDto,
  ) async {
    RespostaModel<ClienteModel> resposta = RespostaModel<ClienteModel>();
    try {
      var clienteAtualizado =
          await _contexto
              .from('clientes')
              .update({
                "nome": atualizarClienteDto.nome,
                "email": atualizarClienteDto.email,
                "data_nascimento":
                    atualizarClienteDto.data_nascimento
                        .toUtc()
                        .toIso8601String()
                        .split('T')[0],
                "senha": atualizarClienteDto.senha,
                "foto_cliente": atualizarClienteDto.foto_cliente,
                "fk_id_telefone": atualizarClienteDto.telefone,
                "fk_id_endereco": atualizarClienteDto.endereco,
              })
              .eq("id_cliente", atualizarClienteDto.id)
              .select()
              .single();

      resposta.Dados = ClienteModel(
        id: clienteAtualizado['id_cliente'],
        nome: clienteAtualizado['nome'],
        email: clienteAtualizado['email'],
        data_nascimento: DateTime.parse(clienteAtualizado['data_nascimento']),
        senha: clienteAtualizado['senha'],
        foto_cliente: clienteAtualizado['foto_cliente'] ?? "",
        telefone: clienteAtualizado['fk_id_telefone'] ?? 0,
        endereco: clienteAtualizado['fk_id_endereco'] ?? 0,
      );

      resposta.Mensagem = "Cliente atualizado com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<ClienteModel>> buscarClientePorId(int id) async {
    RespostaModel<ClienteModel> resposta = RespostaModel<ClienteModel>();
    try {
      var cliente =
          await _contexto
              .from('clientes')
              .select()
              .eq("id_cliente", id)
              .single();

      resposta.Dados = ClienteModel(
        id: cliente['id_cliente'],
        nome: cliente['nome'],
        email: cliente['email'],
        data_nascimento: DateTime.parse(cliente['data_nascimento']),
        senha: cliente['senha'],
        foto_cliente: cliente['foto_cliente'] ?? "",
        telefone: cliente['fk_id_telefone'] ?? 0,
        endereco: cliente['fk_id_endereco'] ?? 0,
      );

      resposta.Mensagem = "Cliente encontrado.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<bool>> excluirCliente(int id) async {
    RespostaModel<bool> resposta = RespostaModel<bool>();
    try {
      await _contexto.from('clientes').delete().eq("id_cliente", id);

      resposta.Dados = true;
      resposta.Mensagem = "Cliente excluído com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Dados = false;
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<ClienteModel>> fazerLogin(LoginDto loginDto) async {
    RespostaModel<ClienteModel> resposta = RespostaModel<ClienteModel>();
    try {
      var cliente =
          await _contexto
              .from('clientes')
              .select()
              .eq("email", loginDto.email)
              .eq("senha", loginDto.senha)
              .maybeSingle();

      if (cliente == null) {
        resposta.Status = HttpStatus.unauthorized;
        resposta.Mensagem = "Credenciais inválidas.";
        return resposta;
      }

      resposta.Dados = ClienteModel(
        id: cliente['id_cliente'],
        nome: cliente['nome'],
        email: cliente['email'],
        data_nascimento: DateTime.parse(cliente['data_nascimento']),
        senha: cliente['senha'],
        foto_cliente: cliente['foto_cliente'] ?? "",
        telefone: cliente['fk_id_telefone'] ?? 0,
        endereco: cliente['fk_id_endereco'] ?? 0,
      );

      resposta.Mensagem = "Login realizado com sucesso.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }

  @override
  Future<RespostaModel<List<ClienteModel>>> listarClientes() async {
    RespostaModel<List<ClienteModel>> resposta =
        RespostaModel<List<ClienteModel>>();
    try {
      var clientes = await _contexto.from('clientes').select();

      resposta.Dados =
          clientes
              .map<ClienteModel>(
                (cliente) => ClienteModel(
                  id: cliente['id_cliente'],
                  nome: cliente['nome'],
                  email: cliente['email'],
                  data_nascimento: DateTime.parse(cliente['data_nascimento']),
                  senha: cliente['senha'],
                  foto_cliente: cliente['foto_cliente'] ?? "",
                  telefone: cliente['fk_id_telefone'] ?? 0,
                  endereco: cliente['fk_id_endereco'] ?? 0,
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

  @override
  Future<RespostaModel<ClienteModel>> criarCliente(
    CriarClienteDto criarClienteDto,
  ) async {
    RespostaModel<ClienteModel> resposta = new RespostaModel<ClienteModel>();
    try {
      var consulta =
          await _contexto
              .from('clientes')
              .select()
              .eq("email", criarClienteDto.email)
              .maybeSingle();

      if (consulta != null) {
        resposta.Status = HttpStatus.conflict;
        resposta.Mensagem = "Tente com outras credenciais.";
        return resposta;
      }

      var novoCliente =
          await _contexto
              .from('clientes')
              .insert({
                "nome": criarClienteDto.nome,
                "email": criarClienteDto.email,
                "data_nascimento":
                    criarClienteDto.data_nascimento
                        .toUtc()
                        .toIso8601String()
                        .split('T')[0],
                "senha": criarClienteDto.senha,
              })
              .select()
              .single();

      resposta.Dados = new ClienteModel(
        id: novoCliente['id_cliente'],
        nome: novoCliente['nome'],
        email: novoCliente['email'],
        data_nascimento: DateTime.parse(novoCliente['data_nascimento']),
        senha: novoCliente['senha'],
        foto_cliente: novoCliente['foto_cliente'] ?? "",
        telefone: novoCliente['fk_id_telefone'] ?? 0,
        endereco: novoCliente['fk_id_endereco'] ?? 0,
      );
      resposta.Mensagem = "Usuário cadastrado com sucesso.";
      resposta.Status = HttpStatus.created;
      return resposta;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
      return resposta;
    }
  }
}
