import 'package:flutter/material.dart';
import '../models/habilidades_model.dart';
import '../repositories/habilidades_repository.dart';

class HabilidadesController extends ChangeNotifier {
  final HabilidadesRepository repository;

  HabilidadesController({required this.repository});

  bool isLoading = false;

  List<Habilidade> _habilidades = [];
  List<Habilidade> get habilidades => _habilidades;

  List<String> habilidadesFiltradas = [];
  List<String> habilidadesSelecionadas = [];

  Future<void> carregarHabilidades(String uid) async {
    isLoading = true;
    notifyListeners();

    try {
      _habilidades = await repository.getHabilidades();
      habilidadesSelecionadas =
          await repository.carregarHabilidadesSelecionadas(uid);

      habilidadesFiltradas = _habilidades.map((h) => h.nome).toList();
    } catch (e) {
      debugPrint("Erro ao carregar habilidades: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void filtrarHabilidades(String filtro) {
    habilidadesFiltradas = _habilidades
        .map((h) => h.nome)
        .where((h) => h.toLowerCase().contains(filtro.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void adicionarHabilidadeSelecionada(String habilidade) {
    if (!habilidadesSelecionadas.contains(habilidade)) {
      habilidadesSelecionadas.add(habilidade);
      notifyListeners();
    }
  }

  void removerHabilidadeSelecionada(String habilidade) {
    habilidadesSelecionadas.remove(habilidade);
    notifyListeners();
  }

  Future<bool> salvarHabilidades(String uid) async {
    try {
      await repository.salvarHabilidadesSelecionadas(
          uid, habilidadesSelecionadas);
      return true;
    } catch (e) {
      debugPrint("Erro ao salvar habilidades: $e");
      return false;
    }
  }
}
