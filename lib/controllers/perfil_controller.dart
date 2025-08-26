import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../repositories/perfil_repository.dart';
import '../models/perfil_model.dart';

class PerfilController {
  final PerfilRepository repository;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  PerfilController({required this.repository});

  Future<PerfilModel?> carregarPerfil(String uid) async {
    return await repository.getPerfil(uid);
  }

  Future<void> salvarPerfil(String uid, PerfilModel perfil) async {
    await repository.savePerfil(uid, perfil);
  }

  // Upload da foto para Storage e atualização do Firestore
  Future<String> uploadFotoPerfil(String uid, File arquivo) async {
    final ref = _storage.ref().child('profissionais/$uid/fotoPerfil.jpg');

    // Faz upload do arquivo
    await ref.putFile(arquivo);

    // Pega a URL da imagem
    final url = await ref.getDownloadURL();

    // Atualiza Firestore com a URL
    await repository.atualizarFotoUrl(uid, url);

    return url;
  }
}
