import 'package:clini_care/components/RecuperarSenha/RecuperarSenha.dart';
import 'package:flutter/material.dart';

class RecuperarSenhaPage extends StatelessWidget {
  const RecuperarSenhaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Color.fromARGB(255, 64, 91, 230)),
        child: RecuperarSenha(),
      ),
    );
  }
}
