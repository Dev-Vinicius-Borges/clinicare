import 'dart:io';

import 'package:clini_care/server/Dtos/cliente/AtualizarClienteDto.dart';
import 'package:clini_care/server/services/ClienteService.dart';
import 'package:clini_care/server/session/configuracao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class RegistroSegurancaForm extends StatefulWidget {
  const RegistroSegurancaForm({super.key});

  @override
  State<RegistroSegurancaForm> createState() => RegistroSegurancaFormState();
}

class RegistroSegurancaFormState extends State<RegistroSegurancaForm> {
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmacaoSenhaController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: SizedBox(
                height: 70,
                child: TextFormField(
                  style: const TextStyle(
                    color: Color.fromARGB(255, 160, 173, 243),
                  ),
                  validator:
                      (String? value) =>
                          !valueValidator(value) ? "Insira a senha" : null,
                  controller: senhaController,
                  decoration: const InputDecoration(
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
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: SizedBox(
                height: 70,
                child: TextFormField(
                  style: const TextStyle(
                    color: Color.fromARGB(255, 160, 173, 243),
                  ),
                  validator: (String? value) {
                    if (!valueValidator(value)) {
                      return "Insira a confirmação da senha.";
                    }

                    if (value != senhaController.text) {
                      return "Senhas não conferem.";
                    }

                    var bytes = utf8.encode(senhaController.text);
                    var digest = sha256.convert(bytes);
                    senhaController.text = digest.toString();

                    return null;
                  },
                  controller: confirmacaoSenhaController,
                  decoration: const InputDecoration(
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
                      "Confirmação da senha",
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
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
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
                    var clienteEncontrado = await ClienteService()
                        .buscarClientePorId(id_usuario)
                        .then((data) => data.Dados!);

                    AtualizarClienteDto atualizacaoCliente = new AtualizarClienteDto(
                      id: id_usuario,
                      nome: clienteEncontrado.nome,
                      email: clienteEncontrado.email,
                      data_nascimento: clienteEncontrado.data_nascimento,
                      senha: senhaController.text,
                      foto_cliente: clienteEncontrado.foto_cliente,
                      telefone: clienteEncontrado.telefone,
                      endereco: clienteEncontrado.endereco,
                    );

                    var atualizacao = await ClienteService().atualizarCliente(atualizacaoCliente);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(atualizacao.Mensagem.toString())),
                    );

                    if(atualizacao.Status == HttpStatus.ok){
                      Navigator.pushNamed(context, "/inicio");
                    }

                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Preencha todos os campos.")),
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
                child: Text(
                  "Criar conta",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Já tem uma conta?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        EdgeInsets.zero,
                      ),
                      minimumSize: WidgetStateProperty.all<Size>(Size(0, 0)),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      overlayColor: WidgetStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                    ),
                    child: const Text(
                      " Entre na sua conta",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
