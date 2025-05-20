import 'package:clini_care/server/Dtos/cliente/AtualizarClienteDto.dart';
import 'package:clini_care/server/services/ClienteService.dart';
import 'package:flutter/material.dart';

class EditarSenhaForm extends StatefulWidget {
  final int id_dados_pessoais;

  const EditarSenhaForm(this.id_dados_pessoais, {super.key});

  @override
  State<EditarSenhaForm> createState() => EditarSenhaFormState();
}

class EditarSenhaFormState extends State<EditarSenhaForm> {
  TextEditingController senhaAntigaController = TextEditingController();
  TextEditingController novaSenhaController = TextEditingController();
  TextEditingController confirmacaoSenhaController = TextEditingController();
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  bool valueValidator(String? value) {
    if (value!.isEmpty) {
      return false;
    }
    return true;
  }

  bool senhasIguaisValidator() {
    return novaSenhaController.text == confirmacaoSenhaController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: SizedBox(
              height: 70,
              child: TextFormField(
                style: TextStyle(color: Color.fromARGB(255, 160, 173, 243)),
                validator:
                    (String? value) =>
                        !valueValidator(value) ? "Insira a senha antiga" : null,
                controller: senhaAntigaController,
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
                    "Senha antiga",
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
                style: TextStyle(color: Color.fromARGB(255, 160, 173, 243)),
                validator:
                    (String? value) =>
                        !valueValidator(value) ? "Insira a nova senha" : null,
                controller: novaSenhaController,
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
                    "Nova senha",
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
                style: TextStyle(color: Color.fromARGB(255, 160, 173, 243)),
                validator: (String? value) {
                  if (!valueValidator(value)) {
                    return "Confirme a nova senha";
                  }
                  if (value != novaSenhaController.text) {
                    return "As senhas não coincidem";
                  }
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
                    "Confirmar nova senha",
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
                      if (senhaAntigaController.text !=
                          clienteAtual.Dados!.senha) {
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Senha antiga incorreta")),
                        );
                        return;
                      }

                      AtualizarClienteDto clienteAtualizado =
                          AtualizarClienteDto(
                            id: widget.id_dados_pessoais,
                            nome: clienteAtual.Dados!.nome,
                            email: clienteAtual.Dados!.email,
                            data_nascimento:
                                clienteAtual.Dados!.data_nascimento,
                            senha: novaSenhaController.text,
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
                            content: Text("Senha atualizada com sucesso!"),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Erro ao atualizar senha: ${resposta.Mensagem}",
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
                      SnackBar(content: Text("Erro ao atualizar senha: $e")),
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
              child:
                  isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                        "Alterar senha",
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
