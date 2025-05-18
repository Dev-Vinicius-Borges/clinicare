import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GerenciadorDeSessao with ChangeNotifier{
  int? _id_usuario;
  int? get idUsuario => _id_usuario;

  Future<void> setIdUsuario(int id) async{
    _id_usuario = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id_usuario', id);
    notifyListeners();
  }

  Future<void> loadSession() async{
    _id_usuario = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id_usuario');
    notifyListeners();
  }

  Future<void> clearSession() async{
    _id_usuario = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id_usuario');
    notifyListeners();
  }
}