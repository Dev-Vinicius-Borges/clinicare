import 'package:clini_care/components/BottomSheetContainer.dart';
import 'package:clini_care/components/bottomSheets/agendamento/EscolherDataDisponivel.dart';
import 'package:clini_care/components/bottomSheets/agendamento/EscolherHorarioDisponivel.dart';
import 'package:clini_care/server/models/MedicoModel.dart';
import 'package:clini_care/server/services/MedicoService.dart';
import 'package:flutter/material.dart';

class ConfirmarAgendamento extends StatefulWidget {
  final int id_profissional;
  final String especialidade;
  final DateTime data_consulta;
  final TimeOfDay hora_consulta;

  const ConfirmarAgendamento(
    this.id_profissional,
    this.especialidade,
    this.data_consulta,
    this.hora_consulta, {
    super.key,
  });

  @override
  State<ConfirmarAgendamento> createState() => _ConfirmarAgendamentoState();
}

class _ConfirmarAgendamentoState extends State<ConfirmarAgendamento> {
  late MedicoModel medico;

  void buscarInfoMedico() async {
    var busca = await MedicoService().buscarMedicoPorId(widget.id_profissional);
    setState(() {
      medico = busca.Dados!;
    });
  }

  @override
  void initState() {
    super.initState();
    buscarInfoMedico();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  medico.foto_medico!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 100),
                ),
              ),
            ),

            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medico.nome,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  widget.especialidade,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        // Data
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 5,
              children: [
                Icon(Icons.calendar_today, size: 20),
                Text(
                  "Data",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context, widget.data_consulta);
                showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  isScrollControlled: true,
                  builder:
                      (context) => BottomSheetContainer(
                        "Escolha uma data",
                        EscolherDataDisponivel(widget.id_profissional),
                      ),
                );
              },
              icon: Icon(Icons.edit, size: 16, color: Colors.white),
              label: Text(
                "Editar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 160, 173, 243),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 22.0),
            child: Text(
              "${widget.data_consulta.day}/${widget.data_consulta.month}/${widget.data_consulta.year}",
              style: TextStyle(fontSize: 13, color: Colors.black),
            ),
          ),
        ),
        SizedBox(height: 10),
        // Horário
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 5,
              children: [
                Icon(Icons.access_time, size: 20),
                Text(
                  "Horário",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context, widget.hora_consulta);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder:
                      (context) => BottomSheetContainer(
                        "Escolha um horário",
                        EscolherHorarioDisponivel(
                          id_profissional: widget.id_profissional,
                          dataEscolhida: widget.data_consulta,
                        ),
                        voltarParaBottomSheetAnterior: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder:
                                (context) => BottomSheetContainer(
                                  "Escolha uma data",
                                  EscolherDataDisponivel(
                                    widget.id_profissional,
                                  ),
                                ),
                          );
                        },
                      ),
                );
              },
              icon: Icon(Icons.edit, size: 16, color: Colors.white),
              label: Text(
                "Editar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 160, 173, 243),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 22.0),
            child: Text(
              '${widget.hora_consulta.hour.toString().padLeft(2, '0')}:${widget.hora_consulta.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.radio_button_checked, color: Colors.blue, size: 16),
            SizedBox(width: 6),
            Expanded(child: Text("Desejo receber uma confirmação por SMS.")),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 64, 91, 230),
            minimumSize: Size(double.infinity, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Agendar consulta",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 230, 64, 67),
            minimumSize: Size(double.infinity, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Cancelar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
