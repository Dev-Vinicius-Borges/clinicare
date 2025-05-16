import 'package:flutter/material.dart';

class AlterarSenhaForm extends StatefulWidget {
  const AlterarSenhaForm({super.key});

  @override
  State<AlterarSenhaForm> createState() =>
      AlterarSenhaFormState();
}

class AlterarSenhaFormState extends State<AlterarSenhaForm> {
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmacaoSenhaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool valueValidator(String? value) {
    if (value!.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: SizedBox(
              height: 70,
              child: TextFormField(
                style: const TextStyle(
                  color: Color.fromARGB(255, 160, 173, 243),
                ),
                validator:
                    (String? value) =>
                !valueValidator(value) ? "Insira a senha" : null,
                controller: senhaController,
                decoration: const InputDecoration(
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
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: SizedBox(
              height: 70,
              child: TextFormField(
                style: const TextStyle(
                  color: Color.fromARGB(255, 160, 173, 243),
                ),
                validator:
                    (String? value) =>
                !valueValidator(value) ? "Insira a confirmação da senha" : null,
                controller: confirmacaoSenhaController,
                decoration: const InputDecoration(
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
                    "Confirmação da senha",
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
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: TextButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/inicio');
                if (_formKey.currentState!.validate()) {
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Preencha todos os campos.")),
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
              child: Text(
                "Alterar senha",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Já tem uma conta?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      EdgeInsets.zero,
                    ),
                    minimumSize: WidgetStateProperty.all<Size>(Size(0, 0)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    overlayColor: WidgetStateProperty.all<Color>(
                      Colors.transparent,
                    ),
                  ),
                  child: const Text(
                    " Entre na sua conta",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
