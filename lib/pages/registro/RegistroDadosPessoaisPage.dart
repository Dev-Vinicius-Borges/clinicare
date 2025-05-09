import 'package:clini_care/components/Forms/registro/RegistroDadosPessoaisForm.dart';
import 'package:clini_care/components/registro/RegistroDadosPessoais.dart';
import 'package:flutter/material.dart';

class RegistroDadosPessoaisPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 64, 91, 230)
        ),
        child: RegistroDadosPessoais(),
      ),
    );
  }
}