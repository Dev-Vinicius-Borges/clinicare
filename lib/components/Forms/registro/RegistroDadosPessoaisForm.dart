import 'dart:io';

import 'package:clini_care/server/Dtos/cliente/CriarClienteDto.dart';
import 'package:clini_care/server/Dtos/telefone/CriarTelefoneDto.dart';
import 'package:clini_care/server/services/ClienteService.dart';
import 'package:clini_care/server/services/TelefoneService.dart';
import 'package:clini_care/server/session/configuracao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegistroDadosPessoaisForm extends StatefulWidget {
  const RegistroDadosPessoaisForm({super.key});

  @override
  State<RegistroDadosPessoaisForm> createState() =>
      RegistroDadosPessoaisFormState();
}

class RegistroDadosPessoaisFormState extends State<RegistroDadosPessoaisForm> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  DateTime? dataNascimento;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  bool valueValidator(String? value) {
    if (value!.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      setState(() {
        dataNascimento = picked;
        dataNascimentoController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
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
              !valueValidator(value) ? "Insira o nome" : null,
              controller: nomeController,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 244, 245, 254),
                filled: true,
                hintText: 'Ex.: João Silva',
                alignLabelWithHint: true,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                label: Text(
                  "Nome",
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
              validator: (String? value) =>
              !valueValidator(value) ? "Insira o e-mail" : null,
              controller: emailController,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 244, 245, 254),
                filled: true,
                hintText: 'Ex.: joao@email.com',
                alignLabelWithHint: true,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                label: Text(
                  "E-mail",
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
              validator: (String? value) =>
              !valueValidator(value) ? "Insira a data de nascimento" : null,
              controller: dataNascimentoController,
              readOnly: true,
              onTap: () => _selecionarData(context),
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 244, 245, 254),
                filled: true,
                hintText: 'Ex.: 01/01/1990',
                alignLabelWithHint: true,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                label: Text(
                  "Data de nascimento",
                  style: TextStyle(
                    color: Color.fromARGB(255, 160, 173, 243),
                    fontSize: 18,
                  ),
                ),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: Color.fromARGB(255, 160, 173, 243),
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
              validator: (String? value) =>
              !valueValidator(value) ? "Insira o telefone" : null,
              controller: telefoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 244, 245, 254),
                filled: true,
                hintText: 'Ex.: (11) 98765-4321',
                alignLabelWithHint: true,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                label: Text(
                  "Telefone",
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
                  if (dataNascimento == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Selecione uma data de nascimento"),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    isLoading = true;
                  });

                  try {
                    if (_formKey.currentState!.validate()) {
                      CriarTelefoneDto novoTelefone = new CriarTelefoneDto(
                        numero: telefoneController.text,
                      );

                      var criarTelefone = await TelefoneService().criarTelefone(
                        novoTelefone,
                      );


                      CriarClienteDto novoCliente = new CriarClienteDto(
                        nome: nomeController.text,
                        email: emailController.text,
                        data_nascimento: DateFormat("dd/MM/yyyy").parse(dataNascimentoController.text),
                        senha: "",
                        foto_cliente: "",
                        telefone: criarTelefone.Dados!.id,
                        endereco: 0,
                      );

                      var criacao = await ClienteService().criarCliente(
                        novoCliente,
                      );

                      setState(() {
                        isLoading = false;
                      });

                      if (criacao.Status == HttpStatus.created) {
                        Provider.of<GerenciadorDeSessao>(
                          context,
                          listen: false,
                        ).setIdUsuario(criacao.Dados!.id);
                        Navigator.pushNamed(context, "/registro/endereco");
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Preencha todos os campos.")),
                      );
                    }

                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erro ao registrar dados: $e")),
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
                "Continuar",
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
