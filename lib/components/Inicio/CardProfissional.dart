import 'package:clini_care/components/BottomSheetContainer.dart';
import 'package:clini_care/components/bottomSheets/agendamento/EscolherData.dart';
import 'package:flutter/material.dart';

class CardProfissional extends StatefulWidget {
  final int id_profissional;
  final String nome_profissional;
  final String especialidade_profissional;
  final bool viradoParaEsquerda;
  final bool ultimoCard;

  CardProfissional(
    this.id_profissional,
    this.nome_profissional,
    this.especialidade_profissional, {
    required this.viradoParaEsquerda,
    required this.ultimoCard,
  });

  @override
  State<CardProfissional> createState() => _CardProfissionalState();
}

class _CardProfissionalState extends State<CardProfissional> {
  @override
  Widget build(BuildContext context) {
    final imagem = Container(
      width: 150,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.horizontal(
          left: widget.viradoParaEsquerda ? Radius.circular(16) : Radius.zero,
          right: widget.viradoParaEsquerda ? Radius.zero : Radius.circular(16),
        ),
      ),
    );

    final texto = Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              widget.viradoParaEsquerda
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: 8,
              crossAxisAlignment:
                  widget.viradoParaEsquerda
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
              children: [
                Text(
                  widget.nome_profissional,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.especialidade_profissional,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isDismissible: false,
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return BottomSheetContainer(
                            'Escolha uma data',
                            EscolherDataDisponivel()
                          );
                        },
                      );

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 64, 91, 230),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Agendar consulta",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: widget.ultimoCard ? EdgeInsets.only(bottom: 136) : EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children:
              widget.viradoParaEsquerda ? [imagem, texto] : [texto, imagem],
        ),
      ),
    );
  }
}
