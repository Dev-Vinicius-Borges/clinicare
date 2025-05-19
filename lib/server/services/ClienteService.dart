import 'dart:io';
import 'package:clini_care/server/Dtos/cliente/AtualizarClienteDto.dart';
import 'package:clini_care/server/Dtos/cliente/CriarClienteDto.dart';
import 'package:clini_care/server/Dtos/cliente/LoginDto.dart';
import 'package:clini_care/server/abstracts/IClienteInterface.dart';
import 'package:clini_care/server/models/ClienteModel.dart';
import 'package:clini_care/server/models/RespostaModel.dart';
import 'package:clini_care/server/services/StorageService.dart';
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
      String? fotoUrl;
      if (atualizarClienteDto.fotoArquivo != null) {
        fotoUrl = await StorageService().atualizarImagem(
          atualizarClienteDto.fotoArquivo!,
          "cliente_${atualizarClienteDto.id}.jpg",
          "cliente",
        );
      }

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
                "foto_cliente": fotoUrl ?? atualizarClienteDto.foto_cliente,
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
        foto_cliente: fotoUrl ?? clienteAtualizado['foto_cliente'] ?? "",
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
              .maybeSingle();

      if (cliente == null) {
        resposta.Status = HttpStatus.notFound;
        resposta.Mensagem = "Usuário não encontrado";
        return resposta;
      }

      String fotoUrl = StorageService().getImagemUrl(
        "cliente_${cliente['id_cliente']}.jpg",
        "cliente",
      );

      resposta.Dados = ClienteModel(
        id: cliente['id_cliente'],
        nome: cliente['nome'],
        email: cliente['email'],
        data_nascimento: DateTime.parse(cliente['data_nascimento']),
        senha: cliente['senha'],
        foto_cliente: fotoUrl,
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
      await StorageService().deletarImagem("cliente_$id.jpg", "cliente");

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
        resposta.Status = HttpStatus.notFound;
        resposta.Mensagem = "Use outras credenciais.";
        return resposta;
      }

      if (loginDto.senha != cliente['senha']) {
        resposta.Status = HttpStatus.unauthorized;
        resposta.Mensagem = "Usuário ou senha inválidos.";
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
      resposta.Status = HttpStatus.accepted;
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

      if (clientes.isEmpty) {
        resposta.Mensagem = "Nenhum cliente encontrado";
        resposta.Status = HttpStatus.notFound;
        return resposta;
      }

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
                "fk_id_telefone": criarClienteDto.telefone
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

  @override
  Future<RespostaModel<ClienteModel>> buscarClientePorEmail(
    String email,
  ) async {
    RespostaModel<ClienteModel> resposta = RespostaModel<ClienteModel>();
    try {
      var cliente =
          await _contexto
              .from('clientes')
              .select()
              .eq("email", email)
              .maybeSingle();

      if (cliente == null) {
        resposta.Status = HttpStatus.notFound;
        resposta.Mensagem = "Usuário não encontrado";

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

      resposta.Mensagem = "Cliente encontrado.";
      resposta.Status = HttpStatus.ok;
    } catch (err) {
      resposta.Status = HttpStatus.internalServerError;
      resposta.Mensagem = "Erro: $err";
    }

    return resposta;
  }
}
