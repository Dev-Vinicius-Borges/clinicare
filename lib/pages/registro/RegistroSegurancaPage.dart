import 'package:clini_care/components/registro/RegistroSeguranca.dart';
import 'package:flutter/material.dart';

class RegistroSegurancaPage extends StatelessWidget {
  const RegistroSegurancaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Color.fromARGB(255, 64, 91, 230)),
        child: RegistroSeguranca(),
      ),
    );
  }
}
