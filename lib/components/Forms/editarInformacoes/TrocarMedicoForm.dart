import 'package:flutter/material.dart';
import 'package:clini_care/components/ListaMedicos.dart';
import 'package:clini_care/server/models/MedicoModel.dart';
import 'package:clini_care/server/services/ConsultaService.dart';
import 'package:clini_care/server/Dtos/consulta/AtualizarConsultaDto.dart';

class TrocarMedicoForm extends StatefulWidget {
  final int idConsulta;
  final int idMedicoAtual;
  final Function onSucesso;

  const TrocarMedicoForm({
    Key? key,
    required this.idConsulta,
    required this.idMedicoAtual,
    required this.onSucesso,
  }) : super(key: key);

  @override
  State<TrocarMedicoForm> createState() => _TrocarMedicoFormState();
}

class _TrocarMedicoFormState extends State<TrocarMedicoForm> {
  bool isLoading = false;
  MedicoModel? medicoSelecionado;

  Future<void> _atualizarMedico() async {
    if (medicoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecione um médico para continuar")),
      );
      return;
    }

    if (medicoSelecionado!.id == widget.idMedicoAtual) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Este já é o médico atual da consulta")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      AtualizarConsultaDto atualizarConsultaDto = AtualizarConsultaDto(
        id_consulta: widget.idConsulta,
        id_medico: medicoSelecionado!.id,
      );

      var resposta = await ConsultaService().atualizarConsulta(atualizarConsultaDto);

      setState(() {
        isLoading = false;
      });

      if (resposta.Status == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Médico alterado com sucesso")),
        );
        Navigator.pop(context);
        widget.onSucesso();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resposta.Mensagem ?? "Erro ao alterar médico")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao alterar médico: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Selecione o novo médico para sua consulta",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListaMedicos(
            onMedicoSelecionado: (medico) {
              setState(() {
                medicoSelecionado = medico;
              });
            },
          ),
        ),
        SizedBox(height: 16),
        if (medicoSelecionado != null)
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: medicoSelecionado!.foto_medico != null && medicoSelecionado!.foto_medico!.isNotEmpty
                      ? NetworkImage(medicoSelecionado!.foto_medico!)
                      : null,
                  child: (medicoSelecionado!.foto_medico == null || medicoSelecionado!.foto_medico!.isEmpty)
                      ? Icon(Icons.person, size: 20, color: Colors.grey[700])
                      : null,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicoSelecionado!.nome,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        medicoSelecionado!.especialidade,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: isLoading ? null : _atualizarMedico,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 64, 91, 230),
            minimumSize: Size(double.infinity, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  "Confirmar troca de médico",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
}
