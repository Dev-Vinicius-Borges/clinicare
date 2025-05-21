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
import 'package:clini_care/server/session/configuracao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: "https://jxcahmhcsfdrnkcknnbs.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp4Y2FobWhjc2Zkcm5rY2tubmJzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc1OTkwMTAsImV4cCI6MjA2MzE3NTAxMH0.8ry2-UYnSiz8tJfp6WDD8oTK-kfWYcQQBI_R6D-PXqU"
  );

  await initializeDateFormatting('pt_BR');

  runApp(
      ChangeNotifierProvider(
        create: (context) => GerenciadorDeSessao()..loadSession(),
        child: MyApp(),
      )
  );
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      locale: const Locale('pt', 'BR'),
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
