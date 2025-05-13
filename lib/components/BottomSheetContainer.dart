import 'package:flutter/material.dart';

class BottomSheetContainer extends StatelessWidget {
  final String titulo;
  final Widget conteudo;

  final VoidCallback? voltarParaBottomSheetAnterior;

  const BottomSheetContainer(
      this.titulo,
      this.conteudo, {
        super.key,
        this.voltarParaBottomSheetAnterior,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 64, 91, 230),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    if (voltarParaBottomSheetAnterior != null) {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 300), () {
                        voltarParaBottomSheetAnterior!();
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(
                    voltarParaBottomSheetAnterior != null ? Icons.arrow_back : Icons.close,
                    size: 32,
                    color: Color.fromARGB(255, 184, 194, 246),
                  ),
                ),
                Expanded(
                  child: Text(
                    titulo,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 184, 194, 246),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.all(16),
            child: conteudo,
          ),
        ],
      ),
    );
  }
}
