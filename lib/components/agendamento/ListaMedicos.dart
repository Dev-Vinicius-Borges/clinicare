import 'package:flutter/material.dart';
import 'package:clini_care/server/models/MedicoModel.dart';
import 'package:clini_care/server/services/MedicoService.dart';

class ListaMedicos extends StatefulWidget {
  final int? especialidadeId;
  final Function(MedicoModel) onMedicoSelecionado;

  const ListaMedicos({
    Key? key,
    this.especialidadeId,
    required this.onMedicoSelecionado,
  }) : super(key: key);

  @override
  State<ListaMedicos> createState() => _ListaMedicosState();
}

class _ListaMedicosState extends State<ListaMedicos> {
  bool isLoading = true;
  List<MedicoModel> medicos = [];
  final MedicoService _medicoService = MedicoService();

  @override
  void initState() {
    super.initState();
    _carregarMedicos();
  }

  Future<void> _carregarMedicos() async {
    setState(() {
      isLoading = true;
    });

    try {
      var resposta = await _medicoService.listarMedicos();
      
      if (resposta.Status == 200 && resposta.Dados != null) {
        List<MedicoModel> todosMedicos = resposta.Dados!;
        
        if (widget.especialidadeId != null) {
          todosMedicos = todosMedicos.where((medico) => 
            medico.id_especialidade == widget.especialidadeId).toList();
        }
        
        setState(() {
          medicos = todosMedicos;
          isLoading = false;
        });
      } else {
        setState(() {
          medicos = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        medicos = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : medicos.isEmpty
            ? Center(
                child: Text(
                  "Nenhum médico encontrado",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: medicos.length,
                itemBuilder: (context, index) {
                  final medico = medicos[index];
                  return InkWell(
                    onTap: () {
                      widget.onMedicoSelecionado(medico);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: medico.foto_medico != null && medico.foto_medico!.isNotEmpty
                                ? NetworkImage(medico.foto_medico!)
                                : null,
                            child: (medico.foto_medico == null || medico.foto_medico!.isEmpty)
                                ? Icon(Icons.person, size: 30, color: Colors.grey[700])
                                : null,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  medico.nome,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  medico.especialidade,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
  }
}
