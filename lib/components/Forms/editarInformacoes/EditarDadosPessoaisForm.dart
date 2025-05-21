import 'package:clini_care/server/Dtos/cliente/AtualizarClienteDto.dart';
import 'package:clini_care/server/Dtos/telefone/AtualizarTelefoneDto.dart';
import 'package:clini_care/server/services/ClienteService.dart';
import 'package:clini_care/server/services/TelefoneService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditarDadosPessoaisForm extends StatefulWidget {
  final int id_dados_pessoais;

  const EditarDadosPessoaisForm(this.id_dados_pessoais, {super.key});

  @override
  State<EditarDadosPessoaisForm> createState() =>
      EditarDadosPessoaisFormState();
}

class EditarDadosPessoaisFormState extends State<EditarDadosPessoaisForm> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  bool isLoading = true;
  DateTime? dataNascimento;
  late int id_telefone;

  final _formKey = GlobalKey<FormState>();

  bool valueValidator(String? value) {
    if (value!.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    buscarCliente();
  }

  Future<void> buscarCliente() async {
    setState(() {
      isLoading = true;
    });

    try {
      var resposta = await ClienteService().buscarClientePorId(
        widget.id_dados_pessoais,
      );

      if (resposta.Status == 200 && resposta.Dados != null) {
        var cliente = resposta.Dados!;
        var telefone = await TelefoneService().buscarTelefonePorId(
          cliente.telefone,
        );

        setState(() {
          nomeController.text = cliente.nome;
          emailController.text = cliente.email;
          dataNascimento = cliente.data_nascimento;
          dataNascimentoController.text = DateFormat(
            'dd/MM/yyyy',
          ).format(cliente.data_nascimento);
          id_telefone = cliente.telefone;
          telefoneController.text = telefone.Dados!.numero.toString() ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dataNascimento ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null && picked != dataNascimento) {
      setState(() {
        dataNascimento = picked;
        dataNascimentoController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  style: TextStyle(color: Color.fromARGB(255, 160, 173, 243)),
                  validator:
                      (String? value) =>
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
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  style: TextStyle(color: Color.fromARGB(255, 160, 173, 243)),
                  validator:
                      (String? value) =>
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
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  style: TextStyle(color: Color.fromARGB(255, 160, 173, 243)),
                  validator:
                      (String? value) =>
                          !valueValidator(value)
                              ? "Insira a data de nascimento"
                              : null,
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
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  style: TextStyle(color: Color.fromARGB(255, 160, 173, 243)),
                  validator:
                      (String? value) =>
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
                    errorStyle: TextStyle(color: Colors.red),
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
                          AtualizarTelefoneDto telefoneAtualizado =
                              new AtualizarTelefoneDto(id: id_telefone, numero: telefoneController.text);

                          var atualizarTelefone = await TelefoneService().atualizarTelefone(telefoneAtualizado).then((telefone) => telefone.Dados!);

                          AtualizarClienteDto clienteAtualizado =
                              AtualizarClienteDto(
                                id: widget.id_dados_pessoais,
                                nome: nomeController.text,
                                email: emailController.text,
                                data_nascimento: dataNascimento!,
                                senha: clienteAtual.Dados!.senha,
                                foto_cliente: clienteAtual.Dados!.foto_cliente,
                                telefone: atualizarTelefone.id,
                                endereco: clienteAtual.Dados!.endereco,
                              );

                          var resposta = await ClienteService()
                              .atualizarCliente(clienteAtualizado);

                          setState(() {
                            isLoading = false;
                          });

                          if (resposta.Status == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Dados atualizados com sucesso!"),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Erro ao atualizar dados: ${resposta.Mensagem}",
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
                            content: Text("Erro ao atualizar dados: $e"),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Preencha todos os campos corretamente.",
                          ),
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
                  child:
                      isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            "Atualizar dados",
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
