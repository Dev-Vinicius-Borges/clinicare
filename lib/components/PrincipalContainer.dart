import 'package:clini_care/components/BarraNavegacao.dart';
import 'package:clini_care/components/BarraNotificacao.dart';
import 'package:flutter/cupertino.dart';

class PrincipalContainer extends StatefulWidget {
  final Widget children;

  const PrincipalContainer(this.children, {super.key});

  @override
  State<PrincipalContainer> createState() => _PrincipalContainerState();
}

class _PrincipalContainerState extends State<PrincipalContainer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 116, left: 16, right: 16),
          child: widget.children,
        ),
        Align(alignment: Alignment.topLeft, child: BarraNotificacao()),
        Align(alignment: Alignment.bottomLeft, child: BarraNavegacao()),
        // navbar
      ],
    );
  }
}
