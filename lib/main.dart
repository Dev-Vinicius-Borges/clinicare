import 'package:clini_care/pages/AgendamentosPage.dart';
import 'package:clini_care/pages/ContaPage.dart';
import 'package:clini_care/pages/IndexPage.dart';
import 'package:clini_care/pages/LoginPage.dart';
import 'package:clini_care/pages/recuperarSenha/RecuperarSenhaPage.dart';
import 'package:clini_care/pages/registro/RegistroDadosPessoaisPage.dart';
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
        '/registro': (context) => RegistroPage(),
        '/recuperar_senha': (context) => RecuperarSenhaPage(),
        '/inicio': (context) => IndexPage(),
        '/conta': (context) => ContaPage(),
        '/agendamentos': (context) => AgendamentosPage()
      },
    );
  }
}
