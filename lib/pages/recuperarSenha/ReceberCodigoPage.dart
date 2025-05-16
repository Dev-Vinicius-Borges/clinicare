import 'package:clini_care/components/RecuperarSenha/ReceberCodigo.dart';
import 'package:flutter/material.dart';

class ReceberCodigoPage extends StatelessWidget{
  const ReceberCodigoPage({super.key});

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