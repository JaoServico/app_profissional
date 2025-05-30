import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../repositories/perfil_repository.dart';
import '../models/perfil_model.dart';

class PerfilController {
  final PerfilRepository repository;

  PerfilController({required this.repository});

  Future<PerfilModel?> carregarPerfil(String uid) async {
    return await repository.getPerfil(uid);
  }

  Future<void> salvarPerfil(String uid, PerfilModel perfil) async {
    await repository.savePerfil(uid, perfil);
  }

  Future<void> atualizarFoto(String uid, File imagem) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref =
          FirebaseStorage.instance.ref().child('fotos_perfil/$uid/$fileName');

      await ref.putFile(imagem);
      final url = await ref.getDownloadURL();

      final perfilAtual = await repository.getPerfil(uid) ??
          PerfilModel(nome: '', detalhes: '', fotoUrl: '');
      final perfilAtualizado = perfilAtual.copyWith(fotoUrl: url);

      await repository.savePerfil(uid, perfilAtualizado);
    } catch (e) {
      debugPrint("Erro ao atualizar a foto: $e");
    }
  }
}
