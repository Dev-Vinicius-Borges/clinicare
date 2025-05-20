import 'package:clini_care/components/Inicio/CardProfissional.dart';
import 'package:clini_care/server/models/HorariosDisponiveisMedicosModel.dart';
import 'package:clini_care/server/services/HorariosDisponiveisMedicosService.dart';
import 'package:flutter/material.dart';

class ListaProfissionais extends StatefulWidget {
  const ListaProfissionais({super.key});

  @override
  _ListaProfissionaisState createState() => _ListaProfissionaisState();
}

class _ListaProfissionaisState extends State<ListaProfissionais> {
  List<HorariosDisponiveisMedicosModel> profissionais = [];
  Map<int, List<HorariosDisponiveisMedicosModel>> agrupados = {};

  @override
  void initState() {
    super.initState();
    carregarProfissionais();
  }

  Future<void> carregarProfissionais() async {
    var resposta =
        await HorariosDisponiveisMedicosService().listarHorariosDisponiveis();

    agrupados.clear();
    for (var item in resposta.Dados!) {
      agrupados.putIfAbsent(item.id_medico, () => []).add(item);
    }

    setState(() {
      profissionais =
          agrupados.entries.map((e) {
            var primeiro = e.value.first;
            return HorariosDisponiveisMedicosModel(
              id_agenda: primeiro.id_agenda,
              id_medico: primeiro.id_medico,
              nome_medico: primeiro.nome_medico,
              foto_medico: primeiro.foto_medico,
              especialidade: primeiro.especialidade,
              data_real: primeiro.data_real,
              horario: primeiro.horario,
            );
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Médicos disponíveis",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child:
              profissionais.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    itemCount: profissionais.length,
                    itemBuilder: (BuildContext context, int index) {
                      final profissional = profissionais[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CardProfissional(
                          profissional.id_medico,
                          profissional.nome_medico,
                          profissional.especialidade,
                          fotoUrl: profissional.foto_medico,
                          viradoParaEsquerda: index % 2 == 0,
                          ultimoCard: index == profissionais.length - 1,
                          horariosDisponiveis:
                              agrupados[profissional.id_medico]!,
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
