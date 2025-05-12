import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BarraNotificacao extends StatefulWidget {
  @override
  _BarraNotificacaoState createState() => _BarraNotificacaoState();
}

class _BarraNotificacaoState extends State<BarraNotificacao> {
  bool expandida = false;

  final List<Map<String, String>> notificacoes = [
    {'titulo': 'Consulta marcada', 'conteudo': 'Você tem uma consulta amanhã às 14h.'},
    {'titulo': 'Consulta cancelada', 'conteudo': 'Sua consulta para o dia X foi cancelada por N motivos'},
    {'titulo': 'Aviso importante', 'conteudo': 'Clínica fechada neste feriado.'},
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: double.infinity,
      height: expandida ? 300 : 100,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 64, 91, 230),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: 40,
                      height: 40,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "CliniCare",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      expandida = !expandida;
                    });
                  },
                  icon: Icon(Icons.notifications_active),
                  color: Colors.white,
                  iconSize: 30,
                ),
              ],
            ),
            if (expandida)
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                    overscroll: false,
                  ),
                  child: ListView.builder(
                    itemCount: notificacoes.length,
                    itemBuilder: (context, index) {
                      final notificacao = notificacoes[index];
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            notificacao['titulo'] ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(notificacao['conteudo'] ?? ''),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
