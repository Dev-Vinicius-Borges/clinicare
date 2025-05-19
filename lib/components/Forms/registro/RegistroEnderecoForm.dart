import 'dart:convert';
import 'dart:io';
import 'package:clini_care/server/Dtos/cliente/AtualizarClienteDto.dart';
import 'package:clini_care/server/Dtos/endereco/CriarEnderecoDto.dart';
import 'package:clini_care/server/services/ClienteService.dart';
import 'package:clini_care/server/services/EnderecoService.dart';
import 'package:clini_care/server/session/configuracao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RegistroEnderecoForm extends StatefulWidget {
  const RegistroEnderecoForm({super.key});

  @override
  State<RegistroEnderecoForm> createState() => RegistroEnderecoFormState();
}

class RegistroEnderecoFormState extends State<RegistroEnderecoForm> {
  TextEditingController cepController = TextEditingController();
  TextEditingController ruaController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  late int? id_usuario;

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

  buscarEndereco(String cep) async {
    final url = Uri.https("cep.awesomeapi.com.br", "json/$cep");
    var response = await http.get(url);

    if (response.statusCode != 200) {
      return;
    }

    final dados = jsonDecode(response.body);

    ruaController.text = dados['address_name'];
    cidadeController.text = dados['city'];
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
                  validator: (String? value) {
                    if (!valueValidator(value)) {
                      return "Insira o CEP.";
                    }
                    if (value!.length < 8 || value.length > 8) {
                      return "Digite o CEP corretamente.";
                    }

                    return null;
                  },
                  controller: cepController,
                  onChanged: (cepDigitado) {
                    buscarEndereco(cepDigitado);
                  },
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(255, 244, 245, 254),
                    filled: true,
                    hintText: 'Ex.: 12345678',
                    alignLabelWithHint: true,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    label: Text(
                      "CEP",
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
                  validator:
                      (String? value) =>
                          !valueValidator(value) ? "Insira a cidade" : null,
                  controller: cidadeController,
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(255, 244, 245, 254),
                    filled: true,
                    hintText: 'Ex.: Cidade X',
                    alignLabelWithHint: true,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    label: Text(
                      "Cidade",
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
                  validator:
                      (String? value) =>
                          !valueValidator(value) ? "Insira a rua" : null,
                  controller: ruaController,
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(255, 244, 245, 254),
                    filled: true,
                    hintText: 'Ex.: Rua X',
                    alignLabelWithHint: true,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    label: Text(
                      "Rua",
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
                  validator:
                      (String? value) =>
                          !valueValidator(value) ? "Insira o número" : null,
                  controller: numeroController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(255, 244, 245, 254),
                    filled: true,
                    hintText: 'Ex.: XXX',
                    alignLabelWithHint: true,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    label: Text(
                      "Número",
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
                        .buscarClientePorId(id_usuario!);

                    CriarEnderecoDto novoEndereco = new CriarEnderecoDto(
                      cep: int.parse(cepController.text),
                      rua: ruaController.text,
                      numero: numeroController.text,
                      cidade: cidadeController.text,
                    );

                    var criarEndereco = await EnderecoService().criarEndereco(
                      novoEndereco,
                    );

                    AtualizarClienteDto clienteAtt = new AtualizarClienteDto(
                      id: id_usuario!,
                      nome: clienteEncontrado.Dados!.nome,
                      email: clienteEncontrado.Dados!.email,
                      data_nascimento: clienteEncontrado.Dados!.data_nascimento,
                      senha: clienteEncontrado.Dados!.senha,
                      foto_cliente: clienteEncontrado.Dados!.foto_cliente,
                      telefone: clienteEncontrado.Dados!.telefone,
                      endereco: criarEndereco.Dados!.id,
                    );

                    var atualizarCliente = await ClienteService()
                        .atualizarCliente(clienteAtt);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(atualizarCliente.Mensagem.toString()),
                      ),
                    );

                    if (atualizarCliente.Status == HttpStatus.ok){
                      Navigator.pushNamed(context, "/registro/seguranca");
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
                  "Continuar",
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
