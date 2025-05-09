import 'package:clini_care/components/RecuperarSenha/ReceberCodigo.dart';
import 'package:clini_care/components/registro/RegistroDadosPessoais.dart';
import 'package:clini_care/components/registro/RegistroEndereco.dart';
import 'package:clini_care/components/registro/RegistroSeguranca.dart';
import 'package:clini_care/pages/AgendamentosPage.dart';
import 'package:clini_care/pages/ContaPage.dart';
import 'package:clini_care/pages/IndexPage.dart';
import 'package:clini_care/pages/LoginPage.dart';
import 'package:clini_care/pages/recuperarSenha/AlterarSenhaPage.dart';
import 'package:clini_care/pages/recuperarSenha/ReceberCodigoPage.dart';
import 'package:clini_care/pages/recuperarSenha/RecuperarSenhaPage.dart';
import 'package:clini_care/pages/registro/RegistroDadosPessoaisPage.dart';
import 'package:clini_care/pages/registro/RegistroEnderecoPage.dart';
import 'package:clini_care/pages/registro/RegistroSegurancaPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/registro': (context) => RegistroDadosPessoaisPage(),
        '/registro/dados_pessoais': (context) => RegistroDadosPessoaisPage(),
        '/registro/endereco': (context) => RegistroEnderecoPage(),
        '/registro/seguranca': (context) => RegistroSegurancaPage(),
        '/recuperar_senha': (context) => RecuperarSenhaPage(),
        '/recuperar_senha/receber_codigo': (context) => ReceberCodigoPage(),
        '/recuperar_senha/criar_nova_senha': (context) => AlterarSenhaPage(),
        '/inicio': (context) => IndexPage(),
        '/conta': (context) => ContaPage(),
        '/agendamentos': (context) => AgendamentosPage()
      },
    );
  }
}
