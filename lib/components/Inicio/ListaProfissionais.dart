import 'package:clini_care/components/Inicio/CardProfissional.dart';
import 'package:flutter/material.dart';

class ListaProfissionais extends StatelessWidget {
  final List<Map<String, dynamic>> profissionais = [
    {'id': 1, 'nome': 'Médico 1', 'especialidade': 'Especialidade 1'},
    {'id': 2, 'nome': 'Médico 2', 'especialidade': 'Especialidade 2'},
    {'id': 3, 'nome': 'Médico 3', 'especialidade': 'Especialidade 3'},
    {'id': 4, 'nome': 'Médico 3', 'especialidade': 'Especialidade 3'},
    {'id': 5, 'nome': 'Médico 3', 'especialidade': 'Especialidade 3'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Médicos disponíveis",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: ListView.builder(
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
