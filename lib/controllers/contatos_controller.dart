import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/contato_model.dart';
import '../repositories/contatos_repository.dart';

class ContatosController extends ChangeNotifier {
  final ContatosRepository repository;

  ContatoModel contatos = ContatoModel();
  bool isLoading = false;

  final uid = FirebaseAuth.instance.currentUser!.uid;

  ContatosController({required this.repository});

  Future<void> carregarContatos() async {
    isLoading = true;
    notifyListeners();

    contatos = await repository.carregarContatos(uid);

    isLoading = false;
    notifyListeners();
  }

  Future<bool> salvarContatos() async {
    try {
      await repository.salvarContatos(uid, contatos);
      return true;
    } catch (e) {
      return false;
    }
  }

  void atualizarContatos(ContatoModel novo) {
    contatos = novo;
    notifyListeners();
  }
}
