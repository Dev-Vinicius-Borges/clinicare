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
    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 64, 91, 230),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
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
                        voltarParaBottomSheetAnterior != null
                            ? Icons.arrow_back
                            : Icons.close,
                        size: 32,
                        color: const Color.fromARGB(255, 184, 194, 246),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      titulo,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 184, 194, 246),
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Flexible(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: conteudo,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
