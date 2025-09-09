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

  // Inicializa o controller: carrega cidades do usuário e cidades da API
  Future<void> init() async {
    isLoading = true;
    notifyListeners();

    // Carrega cidades do Firestore (subcoleção)
    cidadesSelecionadas = await repository.carregarCidades(uid);

    // Carrega cidades disponíveis da API
    cidadesDisponiveis = await repository.buscarCidadesSP();

    isLoading = false;
    notifyListeners();
  }

  // Adiciona cidade à lista de selecionadas
  void adicionarCidade(String nome) {
    if (!cidadesSelecionadas.any((c) => c.nome == nome)) {
      cidadesSelecionadas.add(CidadeModel(nome: nome));
      notifyListeners();
    }
  }

  // Remove cidade da lista de selecionadas
  void removerCidade(String nome) {
    cidadesSelecionadas.removeWhere((c) => c.nome == nome);
    notifyListeners();
  }

  // Salva cidades selecionadas no Firestore (subcoleção)
  Future<void> salvarCidades() async {
    await repository.salvarCidades(uid, cidadesSelecionadas);
  }
}
