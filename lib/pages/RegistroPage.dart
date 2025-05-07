import 'package:clini_care/components/Login.dart';
import 'package:clini_care/components/registro/RegistroDadosPessoais.dart';
import 'package:clini_care/components/registro/RegistroEndereco.dart';
import 'package:clini_care/components/registro/RegistroSeguranca.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/registro/dados_pessoais':
              return MaterialPageRoute(builder: (context) => RegistroDadosPessoais());
            case '/registro/endereco':
              return MaterialPageRoute(builder: (context) => RegistroEndereco());
            case '/registro/seguranca':
              return MaterialPageRoute(builder: (context) => RegistroSeguranca());
            default:
              return MaterialPageRoute(builder: (context) => RegistroDadosPessoais());
          }
        },
      ),
    );
  }
}