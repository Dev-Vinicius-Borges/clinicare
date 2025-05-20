import 'package:clini_care/server/Dtos/cliente/AtualizarClienteDto.dart';
import 'package:clini_care/server/services/ClienteService.dart';
import 'package:flutter/material.dart';

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
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    carregarDadosCliente();
  }

  Future<void> carregarDadosCliente() async {
    setState(() {
      isLoading = true;
    });

    try {
      var resposta = await ClienteService().buscarClientePorId(
        widget.id_dados_pessoais,
      );
      if (resposta.Status == 200 && resposta.Dados != null) {
        setState(() {
          nomeController.text = resposta.Dados!.nome;
          emailController.text = resposta.Dados!.email;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao carregar dados: ${resposta.Mensagem}"),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao carregar dados: $e")));
    }
  }

  bool valueValidator(String? value) {
    if (value!.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Form(
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
                        !valueValidator(value) ? "Insira o nome" : null,
                controller: nomeController,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 244, 245, 254),
                  filled: true,
                  hintText: 'Ex.: John Doe',
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
                        !valueValidator(value) ? "Insira o email" : null,
                controller: emailController,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 244, 245, 254),
                  filled: true,
                  hintText: 'Ex.: email@exemplo.com',
                  alignLabelWithHint: true,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  label: Text(
                    "e-mail",
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
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    var clienteAtual = await ClienteService()
                        .buscarClientePorId(widget.id_dados_pessoais);

                    if (clienteAtual.Status == 200 &&
                        clienteAtual.Dados != null) {
                      var clienteAtualizado = AtualizarClienteDto(
                        id: widget.id_dados_pessoais,
                        nome: nomeController.text,
                        email: emailController.text,
                        data_nascimento: clienteAtual.Dados!.data_nascimento,
                        senha: clienteAtual.Dados!.senha,
                        foto_cliente: clienteAtual.Dados!.foto_cliente,
                        telefone: clienteAtual.Dados!.telefone,
                        endereco: clienteAtual.Dados!.endereco,
                      );

                      var resposta = await ClienteService().atualizarCliente(
                        clienteAtualizado,
                      );

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
                          content: Text(
                            "Erro ao buscar dados atuais do cliente",
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erro ao atualizar dados: $e")),
                    );
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
              child:
                  isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                        "Alterar informações",
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
