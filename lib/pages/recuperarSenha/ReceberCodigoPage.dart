import 'package:clini_care/components/Forms/RecuperarSenha/ReceberCodigoForm.dart';
import 'package:clini_care/components/RecuperarSenha/ReceberCodigo.dart';
import 'package:clini_care/components/RecuperarSenha/RecuperarSenha.dart';
import 'package:flutter/material.dart';

class ReceberCodigoPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 64, 91, 230)
        ),
        child: ReceberCodigo()
      ),
    );
  }
}