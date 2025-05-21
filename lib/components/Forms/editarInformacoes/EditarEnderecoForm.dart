import 'dart:convert';

import 'package:clini_care/server/Dtos/cliente/AtualizarClienteDto.dart';
import 'package:clini_care/server/Dtos/endereco/AtualizarEndereoDto.dart';
import 'package:clini_care/server/Dtos/endereco/CriarEnderecoDto.dart';
import 'package:clini_care/server/models/ClienteModel.dart';
import 'package:clini_care/server/services/ClienteService.dart';
import 'package:clini_care/server/services/EnderecoService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditarEnderecoForm extends StatefulWidget {
  final int id_dados_pessoais;

  const EditarEnderecoForm(this.id_dados_pessoais, {super.key});

  @override
  State<EditarEnderecoForm> createState() => EditarEnderecoFormState();
}

class EditarEnderecoFormState extends State<EditarEnderecoForm> {
  TextEditingController cepController = TextEditingController();
  TextEditingController ruaController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  bool isLoading = false;
  bool buscandoCep = false;
  ClienteModel? cliente;
  int? id_endereco;

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
        setState(() {
          cliente = resposta.Dados;
          id_endereco = cliente!.endereco;
          isLoading = false;
        });

        if (id_endereco != null) {
          buscarEndereco();
        }
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

  Future<void> buscarEndereco() async {
    setState(() {
      isLoading = true;
    });

    try {
      var resposta = await EnderecoService().buscarEnderecoPorId(id_endereco!);

      if (resposta.Status == 200 && resposta.Dados != null) {
        var endereco = resposta.Dados!;

        setState(() {
          cepController.text = endereco.cep.toString();
          ruaController.text = endereco.rua;
          numeroController.text = endereco.numero;
          cidadeController.text = endereco.cidade;
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

  Future<void> buscarCep(String cep) async {
    if (cep.length != 8) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("CEP deve ter 8 dígitos")));
      return;
    }

    setState(() {
      buscandoCep = true;
    });

    try {
      var url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
      var response = await http.get(url);

      setState(() {
        buscandoCep = false;
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data.containsKey('erro')) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("CEP não encontrado")));
          return;
        }

        setState(() {
          ruaController.text = data['logradouro'] ?? '';
          cidadeController.text = data['localidade'] ?? '';
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro ao buscar CEP")));
      }
    } catch (e) {
      setState(() {
        buscandoCep = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao buscar CEP: $e")));
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
                          !valueValidator(value) ? "Insira o CEP" : null,
                  controller: cepController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
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
                    suffixIcon:
                        buscandoCep
                            ? Container(
                              width: 24,
                              height: 24,
                              padding: EdgeInsets.all(6),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color.fromARGB(255, 160, 173, 243),
                              ),
                            )
                            : IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () => buscarCep(cepController.text),
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
                          !valueValidator(value) ? "Insira a rua" : null,
                  controller: ruaController,
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 244, 245, 254),
                    filled: true,
                    hintText: 'Ex.: Rua das Flores',
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
                          !valueValidator(value) ? "Insira o número" : null,
                  controller: numeroController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 244, 245, 254),
                    filled: true,
                    hintText: 'Ex.: 123',
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
                          !valueValidator(value) ? "Insira a cidade" : null,
                  controller: cidadeController,
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 244, 245, 254),
                    filled: true,
                    hintText: 'Ex.: São Paulo',
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
                        if (id_endereco != null) {
                          AtualizarEnderecoDto enderecoAtualizado =
                              AtualizarEnderecoDto(
                                id: id_endereco!,
                                cep: int.parse(cepController.text),
                                rua: ruaController.text,
                                numero: numeroController.text,
                                cidade: cidadeController.text,
                              );

                          var resposta = await EnderecoService()
                              .atualizarEndereco(enderecoAtualizado);

                          setState(() {
                            isLoading = false;
                          });

                          if (resposta.Status == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Endereço atualizado com sucesso!",
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Erro ao atualizar endereço: ${resposta.Mensagem}",
                                ),
                              ),
                            );
                          }
                        } else {
                          CriarEnderecoDto novoEndereco = CriarEnderecoDto(
                            cep: int.parse(cepController.text),
                            rua: ruaController.text,
                            numero: numeroController.text,
                            cidade: cidadeController.text,
                          );

                          var resposta = await EnderecoService().criarEndereco(
                            novoEndereco,
                          );

                          if (resposta.Status == 201 &&
                              resposta.Dados != null) {
                            var clienteAtual = await ClienteService()
                                .buscarClientePorId(widget.id_dados_pessoais);

                            if (clienteAtual.Status == 200 &&
                                clienteAtual.Dados != null) {
                              var clienteAtualizado = AtualizarClienteDto(
                                id: widget.id_dados_pessoais,
                                nome: clienteAtual.Dados!.nome,
                                email: clienteAtual.Dados!.email,
                                data_nascimento:
                                    clienteAtual.Dados!.data_nascimento,
                                senha: clienteAtual.Dados!.senha,
                                foto_cliente: clienteAtual.Dados!.foto_cliente,
                                telefone: clienteAtual.Dados!.telefone,
                                endereco: resposta.Dados!.id,
                              );

                              var respostaCliente = await ClienteService()
                                  .atualizarCliente(clienteAtualizado);

                              setState(() {
                                isLoading = false;
                              });

                              if (respostaCliente.Status == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Endereço adicionado com sucesso!",
                                    ),
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Erro ao atualizar cliente: ${respostaCliente.Mensagem}",
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
                                    "Erro ao buscar dados do cliente",
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
                                  "Erro ao criar endereço: ${resposta.Mensagem}",
                                ),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Erro ao atualizar endereço: $e"),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Preencha todos os campos obrigatórios.",
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
                            id_endereco != null
                                ? "Atualizar endereço"
                                : "Adicionar endereço",
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
