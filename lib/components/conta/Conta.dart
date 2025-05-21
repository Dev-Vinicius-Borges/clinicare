import 'package:clini_care/components/BottomSheetContainer.dart';
import 'package:clini_care/components/Forms/editarInformacoes/EditarDadosPessoaisForm.dart';
import 'package:clini_care/components/Forms/editarInformacoes/EditarEnderecoForm.dart';
import 'package:clini_care/components/Forms/editarInformacoes/EditarSenhaForm.dart';
import 'package:clini_care/server/models/InformacoesClientesCompletoModel.dart';
import 'package:clini_care/server/services/InformacoesClientesCompletosService.dart';
import 'package:clini_care/server/session/configuracao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Conta extends StatefulWidget {
  const Conta({super.key});

  @override
  State<Conta> createState() => _ContaState();
}

class _ContaState extends State<Conta> {
  late int id_usuario;
  late InformacoesClientesCompletosModel cliente;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    id_usuario =
        Provider.of<GerenciadorDeSessao>(context, listen: false).idUsuario!;
    carregarDadosCliente();
  }

  Future<void> carregarDadosCliente() async {
    setState(() {
      isLoading = true;
    });

    try {
      var resposta = await InformacoesClientesCompletosService()
          .buscarInformacoesClientePorId(id_usuario);
      if (resposta.Status == 200 && resposta.Dados != null) {
        setState(() {
          cliente = resposta.Dados!;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Erro ao carregar dados do cliente: ${resposta.Mensagem}",
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar dados do cliente: $e")),
      );
    }
  }

  Widget secao(String title, {IconData? icon, required VoidCallback onEdit}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) Icon(icon, color: Color.fromARGB(255, 64, 91, 230)),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: isGray ? Colors.grey : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _abrirEditarDadosPessoais() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder:
          (context) => BottomSheetContainer(
            "Alterar dados pessoais",
            EditarDadosPessoaisForm(id_usuario),
          ),
    ).then((_) {
      carregarDadosCliente();
    });
  }

  void _abrirEditarEndereco() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder:
          (context) => BottomSheetContainer(
            "Alterar Endereço",
            EditarEnderecoForm(id_usuario),
          ),
    ).then((_) {
      carregarDadosCliente();
    });
  }

  void _abrirEditarSenha() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder:
          (context) => BottomSheetContainer(
            "Alterar senha",
            EditarSenhaForm(id_usuario),
          ),
    ).then((_) {
      carregarDadosCliente();
    });
  }

  void _sairDaConta() async {
    await Provider.of<GerenciadorDeSessao>(
      context,
      listen: false,
    ).clearSession();

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(bottom: 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Color.fromARGB(255, 64, 91, 230),
                child: Icon(Icons.person, color: Colors.white, size: 40),
              ),
              SizedBox(width: 16),
              Text(
                cliente.nome,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 32, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                secao("Dados pessoais", onEdit: _abrirEditarDadosPessoais),
                campo("Nome", cliente.nome),
                campo("Email", cliente.email, isGray: true),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                secao(
                  "Endereço",
                  icon: Icons.location_on,
                  onEdit: _abrirEditarEndereco,
                ),
                campo("CEP", cliente.cep.toString()),
                campo("Rua", cliente.rua),
                campo("Número", cliente.numero),
                campo("Cidade", cliente.cidade, isGray: true),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                secao("Senha", icon: Icons.lock, onEdit: _abrirEditarSenha),
                campo("Senha", "••••••••", isGray: true),
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
            onPressed: _sairDaConta,
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
