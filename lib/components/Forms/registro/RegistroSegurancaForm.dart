import 'dart:convert';

import 'package:clini_care/server/Dtos/cliente/AtualizarClienteDto.dart';
import 'package:clini_care/server/services/ClienteService.dart';
import 'package:clini_care/server/session/configuracao.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistroSegurancaForm extends StatefulWidget {
  final int id_dados_pessoais;

  const RegistroSegurancaForm(this.id_dados_pessoais, {super.key});

  @override
  State<RegistroSegurancaForm> createState() => RegistroSegurancaFormState();
}

class RegistroSegurancaFormState extends State<RegistroSegurancaForm> {
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmacaoSenhaController = TextEditingController();
  bool isLoading = false;late String hashSenha;
  late int id_usuario;

  @override
  void initState() {
    super.initState();

    id_usuario =
    Provider.of<GerenciadorDeSessao>(context, listen: false).idUsuario!;
  }

  final _formKey = GlobalKey<FormState>();

  bool valueValidator(String? value) {
    if (value!.isEmpty) {
      return false;
    }
    return true;
  }

  bool senhasIguaisValidator() {
    return senhaController.text == confirmacaoSenhaController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: TextFormField(
              style: TextStyle(color: Color.fromARGB(255, 160, 173, 243)),
              validator: (String? value) =>
                  !valueValidator(value) ? "Insira a senha" : null,
              controller: senhaController,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 244, 245, 254),
                filled: true,
                hintText: 'Ex.: ********',
                alignLabelWithHint: true,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                label: Text(
                  "Senha",
                  style: TextStyle(
                    color: Color.fromARGB(255, 160, 173, 243),
                    fontSize: 18,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                errorStyle: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: TextFormField(
              style: TextStyle(color: Color.fromARGB(255, 160, 173, 243)),
              validator: (String? value) {
                if (!valueValidator(value)) {
                  return "Insira a confirmação da senha.";
                }

                if (value != senhaController.text) {
                  return "Senhas não conferem.";
                }

                var bytes = utf8.encode(senhaController.text);
                var digest = sha256.convert(bytes);
                hashSenha = digest.toString();

                return null;
              },
              controller: confirmacaoSenhaController,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 244, 245, 254),
                filled: true,
                hintText: 'Ex.: ********',
                alignLabelWithHint: true,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                label: Text(
                  "Confirmar senha",
                  style: TextStyle(
                    color: Color.fromARGB(255, 160, 173, 243),
                    fontSize: 18,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                errorStyle: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    var clienteAtual = await ClienteService()
                        .buscarClientePorId(widget.id_dados_pessoais);

                    if (clienteAtual.Status == 200 &&
                        clienteAtual.Dados != null) {
                      var clienteEncontrado = await ClienteService()
                          .buscarClientePorId(id_usuario)
                          .then((data) => data.Dados!);

                      AtualizarClienteDto atualizacaoCliente =
                      new AtualizarClienteDto(
                        id: id_usuario,
                        nome: clienteEncontrado.nome,
                        email: clienteEncontrado.email,
                        data_nascimento: clienteEncontrado.data_nascimento,
                        senha: hashSenha,
                        foto_cliente: clienteEncontrado.foto_cliente,
                        telefone: clienteEncontrado.telefone,
                        endereco: clienteEncontrado.endereco,
                      );

                      var resposta = await ClienteService().atualizarCliente(
                        atualizacaoCliente,
                      );

                      setState(() {
                        isLoading = false;
                      });

                      if (resposta.Status == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Cadastro concluído com sucesso!"),
                          ),
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Erro ao finalizar cadastro: ${resposta.Mensagem}",
                            ),
                          ),
                        );
                      }
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Erro ao buscar dados do cliente"),
                        ),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Erro ao finalizar cadastro: $e")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Preencha todos os campos corretamente."),
                    ),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  Color.fromARGB(255, 85, 103, 254),
                ),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Finalizar cadastro",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
