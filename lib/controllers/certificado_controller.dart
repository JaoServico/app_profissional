import 'package:flutter/material.dart';
import '../models/certificado_model.dart';
import '../repositories/certificado_repository.dart';

class CertificadoController extends ChangeNotifier {
  final CertificadoRepository repository;

  CertificadoController({required this.repository});

  List<CertificadoModel> certificados = [];
  List<TextEditingController> controllersNome = [];
  List<TextEditingController> controllersData = [];
  bool isLoading = true;

  Future<void> carregarCertificados(String uid) async {
    isLoading = true;
    notifyListeners();

    certificados = await repository.getCertificados(uid);

    controllersNome = certificados.map((c) => TextEditingController(text: c.nome)).toList();
    controllersData = certificados.map((c) => TextEditingController(text: c.data)).toList();

    isLoading = false;
    notifyListeners();
  }

  void adicionarCertificado() {
    certificados.add(CertificadoModel(nome: '', data: ''));
    controllersNome.add(TextEditingController());
    controllersData.add(TextEditingController());
    notifyListeners();
  }

  void removerCertificado(int index) {
    certificados.removeAt(index);
    controllersNome.removeAt(index);
    controllersData.removeAt(index);
    notifyListeners();
  }

  Future<void> salvarCertificados(String uid) async {
    for (int i = 0; i < certificados.length; i++) {
      certificados[i].nome = controllersNome[i].text;
      certificados[i].data = controllersData[i].text;
    }

    await repository.saveCertificados(uid, certificados);
  }
}
