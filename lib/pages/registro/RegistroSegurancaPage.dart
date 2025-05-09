import 'package:clini_care/components/Forms/registro/RegistroDadosPessoaisForm.dart';
import 'package:clini_care/components/registro/RegistroDadosPessoais.dart';
import 'package:clini_care/components/registro/RegistroEndereco.dart';
import 'package:clini_care/components/registro/RegistroSeguranca.dart';
import 'package:flutter/material.dart';

class RegistroSegurancaPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 64, 91, 230)
        ),
        child: RegistroSeguranca(),
      ),
    );
  }
}