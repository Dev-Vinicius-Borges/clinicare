import 'package:flutter/material.dart';

class RegistroPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 64, 91, 230)
        ),
        child: Center(
          child: Text("Registro", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}