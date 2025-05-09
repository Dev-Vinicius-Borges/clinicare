import 'package:clini_care/components/Forms/RecuperarSenha/AlterarSenhaForm.dart';
import 'package:clini_care/components/RecuperarSenha/AlterarSenha.dart';
import 'package:clini_care/components/RecuperarSenha/RecuperarSenha.dart';
import 'package:flutter/material.dart';

class AlterarSenhaPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 64, 91, 230)
        ),
        child: AlterarSenha()
      ),
    );
  }
}