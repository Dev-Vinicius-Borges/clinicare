import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _supabase;

  StorageService() : _supabase = Supabase.instance.client;

  Future<String?> uploadImagem(
    File imagem,
    String nomeArquivo,
    String bucket,
  ) async {
    try {
      await _supabase.storage.from(bucket).upload(nomeArquivo, imagem);
      return _supabase.storage.from(bucket).getPublicUrl(nomeArquivo);
    } catch (err) {
      print("Erro ao fazer upload: $err");
      return null;
    }
  }

  Future<String?> atualizarImagem(
    File novaImagem,
    String nomeArquivo,
    String bucket,
  ) async {
    try {
      await _supabase.storage.from(bucket).remove([nomeArquivo]);
      await _supabase.storage.from(bucket).upload(nomeArquivo, novaImagem);
      return _supabase.storage.from(bucket).getPublicUrl(nomeArquivo);
    } catch (err) {
      print("Erro ao atualizar imagem: $err");
      return null;
    }
  }

  Future<bool> deletarImagem(String nomeArquivo, String bucket) async {
    try {
      await _supabase.storage.from(bucket).remove([nomeArquivo]);
      return true;
    } catch (err) {
      print("Erro ao deletar imagem: $err");
      return false;
    }
  }

  String getImagemUrl(String nomeArquivo, String bucket) {
    return _supabase.storage.from(bucket).getPublicUrl(nomeArquivo);
  }
}
