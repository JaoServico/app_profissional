import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/cidade_model.dart';
import '../repositories/cidade_repository.dart';

class CidadeController extends ChangeNotifier {
  final CidadeRepository repository;

  CidadeController({required this.repository});

  List<CidadeModel> cidadesSelecionadas = [];
  List<String> cidadesDisponiveis = [];
  bool isLoading = false;

  final uid = FirebaseAuth.instance.currentUser!.uid;

  // Carrega cidades do usuário + cidades disponíveis da API
  Future<void> init() async {
    isLoading = true;
    notifyListeners();

    cidadesSelecionadas = await repository.carregarCidades(uid);
    cidadesDisponiveis = await repository.buscarCidadesSP();

    isLoading = false;
    notifyListeners();
  }

  void adicionarCidade(String nome) {
    if (!cidadesSelecionadas.any((c) => c.nome == nome)) {
      cidadesSelecionadas.add(CidadeModel(nome: nome));
      notifyListeners();
    }
  }

  void removerCidade(String nome) {
    cidadesSelecionadas.removeWhere((c) => c.nome == nome);
    notifyListeners();
  }

  Future<void> salvarCidades() async {
    await repository.salvarCidades(uid, cidadesSelecionadas);
  }
}
