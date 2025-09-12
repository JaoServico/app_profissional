import 'package:flutter/material.dart';
import '../models/negocio_model.dart';
import '../repositories/negocio_repository.dart';

class NegocioController extends ChangeNotifier {
  final NegocioRepository repository; // injetado pelo construtor

  NegocioModel negocio = NegocioModel.vazio();
  bool isLoading = false;

  NegocioController({required this.repository});

  Future<void> carregarNegocio() async {
    isLoading = true;
    notifyListeners();

    final dados = await repository.carregarNegocio();
    if (dados != null) {
      negocio = dados;
    }

    isLoading = false;
    notifyListeners();
  }

  void atualizarNegocio(NegocioModel novo) {
    negocio = novo;
    notifyListeners();
  }

  Future<bool> salvarNegocio() async {
    isLoading = true;
    notifyListeners();

    final sucesso = await repository.salvarNegocio(negocio);

    isLoading = false;
    notifyListeners();

    return sucesso;
  }
}
