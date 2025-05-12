import 'package:clini_care/components/PrincipalContainer.dart';
import 'package:flutter/material.dart';

class ContaPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: PrincipalContainer(Text("Conta", style: TextStyle(color: Colors.black),)),
      ),
    );
  }
}