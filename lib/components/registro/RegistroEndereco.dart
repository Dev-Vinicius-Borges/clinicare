import 'package:clini_care/components/Forms/registro/RegistroEnderecoForm.dart';
import 'package:clini_care/server/session/configuracao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class RegistroEndereco extends StatelessWidget {
  const RegistroEndereco({super.key});

  @override
  Widget build(BuildContext context) {
    int id_dados_pessoais =
        Provider.of<GerenciadorDeSessao>(context, listen: false).idUsuario!;
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 32),
                child: Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 70,
                    height: 70,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "Endereço",
                  style: TextStyle(
                    color: Color.fromARGB(255, 208, 214, 249),
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 32, left: 16, right: 16),
                child: Text(
                  "Precisamos saber onde você mora.",
                  style: TextStyle(
                    color: Color.fromARGB(255, 184, 194, 246),
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: RegistroEnderecoForm(id_dados_pessoais),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
