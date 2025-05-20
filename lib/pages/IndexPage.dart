import 'package:clini_care/components/Inicio/ListaProfissionais.dart';
import 'package:clini_care/components/PrincipalContainer.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: PrincipalContainer(ListaProfissionais()),
      ),
    );
  }
}
