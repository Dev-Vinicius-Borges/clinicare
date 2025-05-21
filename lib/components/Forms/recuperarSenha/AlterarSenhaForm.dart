import 'package:flutter/material.dart';

class AlterarSenhaForm extends StatefulWidget {
  AlterarSenhaForm({super.key});

  @override
  State<AlterarSenhaForm> createState() => AlterarSenhaFormState();
}

class AlterarSenhaFormState extends State<AlterarSenhaForm> {
  TextEditingController novaSenhaController = TextEditingController();
  TextEditingController confirmacaoSenhaController = TextEditingController();
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  bool valueValidator(String? value) {
    if (value!.isEmpty) {
      return false;
    }
    return true;
  }

  bool senhasIguaisValidator() {
    return novaSenhaController.text == confirmacaoSenhaController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: TextFormField(
              style: TextStyle(color: Color.fromARGB(255, 160, 173, 243)),
              validator:
                  (String? value) =>
                      !valueValidator(value) ? "Insira a nova senha" : null,
              controller: novaSenhaController,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 244, 245, 254),
                filled: true,
                hintText: 'Ex.: ********',
                alignLabelWithHint: true,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                label: Text(
                  "Nova senha",
                  style: TextStyle(
                    color: Color.fromARGB(255, 160, 173, 243),
                    fontSize: 18,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                errorStyle: TextStyle(color: Colors.red),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: TextFormField(
              style: TextStyle(color: Color.fromARGB(255, 160, 173, 243)),
              validator: (String? value) {
                if (!valueValidator(value)) {
                  return "Confirme a nova senha";
                }
                if (value != novaSenhaController.text) {
                  return "As senhas não coincidem";
                }
                return null;
              },
              controller: confirmacaoSenhaController,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 244, 245, 254),
                filled: true,
                hintText: 'Ex.: ********',
                alignLabelWithHint: true,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                label: Text(
                  "Confirmar nova senha",
                  style: TextStyle(
                    color: Color.fromARGB(255, 160, 173, 243),
                    fontSize: 18,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                errorStyle: TextStyle(color: Colors.red),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    setState(() {
                      isLoading = false;
                    });
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erro ao alterar senha: $e")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Preencha todos os campos corretamente."),
                    ),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  Color.fromARGB(255, 85, 103, 254),
                ),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              child:
                  isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                        "Alterar senha",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
