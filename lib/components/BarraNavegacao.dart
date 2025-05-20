import 'package:flutter/material.dart';

class BarraNavegacao extends StatelessWidget {
  const BarraNavegacao({super.key});

  @override
  Widget build(BuildContext context) {
    final rotaAtual = ModalRoute.of(context)?.settings.name;

    Widget buildBotao({
      required IconData icone,
      required String texto,
      required String rota,
    }) {
      final estaAtivo = rotaAtual == rota;

      final buttonChild =
          estaAtivo
              ? SizedBox.expand(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icone, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      texto,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              )
              : Center(child: Icon(icone, color: Colors.white, size: 24));

      final botaoNav = ElevatedButton(
        onPressed: () {
          if (!estaAtivo) Navigator.pushNamed(context, rota);
        },
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(
            estaAtivo
                ? Color.fromARGB(255, 88, 112, 234)
                : Color.fromARGB(255, 136, 153, 240),
          ),
          elevation: WidgetStatePropertyAll<double>(0),
        ),
        child: buttonChild,
      );

      return estaAtivo ? Expanded(child: botaoNav) : botaoNav;
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 350,
          height: 100,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 208, 214, 249),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              spacing: 16,
              children: [
                buildBotao(icone: Icons.person, texto: 'Conta', rota: '/conta'),
                buildBotao(
                  icone: Icons.house,
                  texto: 'Início',
                  rota: '/inicio',
                ),
                buildBotao(
                  icone: Icons.calendar_month,
                  texto: 'Agenda',
                  rota: '/agendamentos',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
