import 'package:clini_care/components/Inicio/CardProfissional.dart';
import 'package:clini_care/server/services/MedicoService.dart';
import 'package:flutter/material.dart';

class ListaProfissionais extends StatefulWidget {
  const ListaProfissionais({super.key});

  @override
  _ListaProfissionaisState createState() => _ListaProfissionaisState();
}

class _ListaProfissionaisState extends State<ListaProfissionais> {
  List<Map<String, dynamic>> profissionais = [];

  @override
  void initState() {
    super.initState();
    carregarProfissionais();
  }

  Future<void> carregarProfissionais() async {
    List<Map<String, dynamic>> lista = await MedicoService().buscarListaProfissionais();
    setState(() {
      profissionais = lista;
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
          child: profissionais.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: profissionais.length,
            itemBuilder: (BuildContext context, int index) {
              final profissional = profissionais[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CardProfissional(
                  profissional['id'],
                  profissional['nome'],
                  profissional['especialidade'],
                  viradoParaEsquerda: index % 2 == 0,
                  ultimoCard: index == profissionais.length - 1,
                  fotoUrl: profissional['foto'],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
