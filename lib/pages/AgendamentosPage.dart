import 'package:clini_care/components/PrincipalContainer.dart';
import 'package:clini_care/components/agendamento/AgendamentosFeitos.dart';
import 'package:flutter/material.dart';

class AgendamentosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: PrincipalContainer(AgendamentoFeitos()),
      ),
    );
  }
}
