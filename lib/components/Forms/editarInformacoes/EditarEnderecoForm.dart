import 'dart:convert';

import 'package:clini_care/server/Dtos/cliente/AtualizarClienteDto.dart';
import 'package:clini_care/server/Dtos/endereco/AtualizarEndereoDto.dart';
import 'package:clini_care/server/Dtos/endereco/CriarEnderecoDto.dart';
import 'package:clini_care/server/services/ClienteService.dart';
import 'package:clini_care/server/services/EnderecoService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditarEnderecoForm extends StatefulWidget {
  final int id_usuario;

  const EditarEnderecoForm(this.id_usuario, {super.key});

  @override
  State<EditarEnderecoForm> createState() => EditarEnderecoFormState();
}

class EditarEnderecoFormState extends State<EditarEnderecoForm> {
  TextEditingController cepController = TextEditingController();
  TextEditingController ruaController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  bool isLoading = true;
  bool isBuscandoCep = false;
  int? id_endereco;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Carregar dados atuais do endereço
    carregarDadosEndereco();
  }

  Future<void> carregarDadosEndereco() async {
    setState(() {
      isLoading = true;
    });

    try {
      var clienteResposta = await ClienteService().buscarClientePorId(
        widget.id_usuario,
      );

      if (clienteResposta.Status == 200 && clienteResposta.Dados != null) {
        if (clienteResposta.Dados!.endereco > 0) {
          var enderecoResposta = await EnderecoService().buscarEnderecoPorId(
            clienteResposta.Dados!.endereco,
          );

          if (enderecoResposta.Status == 200 &&
              enderecoResposta.Dados != null) {
            setState(() {
              id_endereco = enderecoResposta.Dados!.id;
              cepController.text = enderecoResposta.Dados!.cep.toString();
              ruaController.text = enderecoResposta.Dados!.rua;
              numeroController.text = enderecoResposta.Dados!.numero;
              cidadeController.text = enderecoResposta.Dados!.cidade;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Erro ao carregar dados do endereço: ${enderecoResposta.Mensagem}",
                ),
              ),
            );
          }
        } else {
          setState(() {
            isLoading = false;
          });
          // Cliente não tem endereço associado
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Você ainda não possui um endereço cadastrado. Cadastre um agora.",
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
              "Erro ao carregar dados do cliente: ${clienteResposta.Mensagem}",
            ),
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

  Future<void> buscarEndereco(String cep) async {
    if (cep.length == 8) {
      setState(() {
        isBuscandoCep = true;
      });

      try {
        final url = Uri.https("cep.awesomeapi.com.br", "json/$cep");
        var response = await http.get(url);

        if (response.statusCode == 200) {
          final dados = jsonDecode(response.body);

          setState(() {
            ruaController.text = dados['address_name'];
            cidadeController.text = dados['city'];
            isBuscandoCep = false;
          });
        } else {
          setState(() {
            isBuscandoCep = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("CEP não encontrado")));
        }
      } catch (e) {
        setState(() {
          isBuscandoCep = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro ao buscar CEP: $e")));
      }
    }
  }

  Future<void> atualizarEndereco() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Verificar se já existe um id de endereço
        if (id_endereco != null) {
          var atualizarEnderecoDto = AtualizarEnderecoDto(
            id: id_endereco!,
            cep: int.parse(cepController.text),
            rua: ruaController.text,
            numero: numeroController.text,
            cidade: cidadeController.text,
          );

          var resposta = await EnderecoService().atualizarEndereco(
            atualizarEnderecoDto,
          );

          setState(() {
            isLoading = false;
          });

          if (resposta.Status == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Endereço atualizado com sucesso!")),
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
          CriarEnderecoDto criarEnderecoDto = new CriarEnderecoDto(
            cep: int.parse(cepController.text),
            rua: ruaController.text,
            numero: numeroController.text,
            cidade: cidadeController.text,
          );

          var resposta = await EnderecoService().criarEndereco(
            criarEnderecoDto,
          );

          if (resposta.Status == 201 && resposta.Dados != null) {
            var clienteResposta = await ClienteService().buscarClientePorId(
              widget.id_usuario,
            );

            if (clienteResposta.Status == 200 &&
                clienteResposta.Dados != null) {
              AtualizarClienteDto clienteAtualizado = new AtualizarClienteDto(
                id: widget.id_usuario,
                nome: clienteResposta.Dados!.nome,
                email: clienteResposta.Dados!.email,
                data_nascimento: clienteResposta.Dados!.data_nascimento,
                senha: clienteResposta.Dados!.senha,
                foto_cliente: clienteResposta.Dados!.foto_cliente,
                telefone: clienteResposta.Dados!.telefone,
                endereco: resposta.Dados!.id,
              );

              var atualizarClienteResposta = await ClienteService()
                  .atualizarCliente(clienteAtualizado);

              setState(() {
                isLoading = false;
              });

              if (atualizarClienteResposta.Status == 200) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Endereço cadastrado com sucesso!")),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Erro ao associar endereço ao cliente: ${atualizarClienteResposta.Mensagem}",
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
                    "Erro ao buscar dados do cliente: ${clienteResposta.Mensagem}",
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
                content: Text("Erro ao criar endereço: ${resposta.Mensagem}"),
              ),
            );
          }
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao processar operação: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos corretamente.")),
      );
    }
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
                validator: (String? value) {
                  if (!valueValidator(value)) {
                    return "Insira o CEP";
                  }
                  if (value!.length != 8) {
                    return "CEP deve ter 8 dígitos";
                  }
                  return null;
                },
                controller: cepController,
                onChanged: (cepDigitado) {
                  if (cepDigitado.length == 8) {
                    buscarEndereco(cepDigitado);
                  }
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
          if (isBuscandoCep)
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: LinearProgressIndicator(),
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
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 244, 245, 254),
                  filled: true,
                  hintText: 'Ex.: 100 A',
                  alignLabelWithHint: true,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  label: Text(
                    "Número da residência",
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
          SizedBox(
            width: double.infinity,
            height: 60,
            child: TextButton(
              onPressed: isLoading ? null : atualizarEndereco,
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
                        "Alterar endereço",
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
