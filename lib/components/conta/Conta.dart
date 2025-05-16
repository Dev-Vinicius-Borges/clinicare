import 'package:clini_care/components/BottomSheetContainer.dart';
import 'package:clini_care/components/Forms/editarInformacoes/EditarDadosPessoaisForm.dart';
import 'package:clini_care/components/Forms/editarInformacoes/EditarEnderecoForm.dart';
import 'package:clini_care/components/Forms/editarInformacoes/EditarSenhaForm.dart';
import 'package:flutter/material.dart';

class Conta extends StatefulWidget {
  const Conta({super.key});

  @override
  State<Conta> createState() => _ContaState();
}

class _ContaState extends State<Conta> {
  late String nome;
  late String email;
  late int cep;
  late String rua;
  late String numero;
  late String cidade;
  late String senha;

  @override
  void initState() {
    super.initState();

    nome = "John";
    email = "John@doe.com";
    cep = 12345678;
    rua = "Rua x";
    numero = "99";
    cidade = "Cidade X";
    senha = "********";
  }

  Widget secao(String title, {IconData? icon, required VoidCallback onEdit}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) Icon(icon, color: Colors.deepPurple),
            if (icon != null) SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: onEdit,
          icon: Icon(Icons.edit, size: 18, color: Colors.white),
          label: Text(
            "Editar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 64, 91, 230),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget campo(String label, String value, {bool isGray = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isGray ? Colors.grey : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.person, color: Colors.white, size: 40),
              ),

              Text(
                "Nome do usuário",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                secao(
                  "Dados pessoais",
                  onEdit: () {

                    showModalBottomSheet(
                      context: context,
                      isDismissible: false,
                      builder:
                          (context) => BottomSheetContainer(
                            "Alterar dados pessoais",
                            EditarDadosPessoaisForm(1),
                          ),
                    );
                  },
                ),
                campo("Nome", nome),
                campo("Email", email, isGray: true),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                secao("Endereço", icon: Icons.location_on, onEdit: () {
                  showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    builder:
                        (context) => BottomSheetContainer(
                      "Alterar Endereço",
                      EditarEnderecoForm(1),
                    ),
                  );
                }),
                campo("CEP", cep.toString()),
                campo("Rua", rua),
                campo("Número", numero),
                campo("Cidade", cidade, isGray: true),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                secao("Senha", icon: Icons.lock, onEdit: () {
                  showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    builder:
                        (context) => BottomSheetContainer(
                      "Alterar senha",
                      EditarSenhaForm(1),
                    ),
                  );
                }),
                campo("Senha", senha, isGray: true),
              ],
            ),
          ),

          ElevatedButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 64, 91, 230),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: () {},
            icon: Icon(Icons.logout, color: Colors.white),
            label: Text(
              "Sair",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
