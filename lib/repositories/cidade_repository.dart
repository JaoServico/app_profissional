import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cidade_model.dart';

class CidadeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Salva cidades selecionadas do usuário
  Future<void> salvarCidades(String uid, List<CidadeModel> cidades) async {
    final cidadesMap = cidades.map((c) => c.toMap()).toList();
    await _firestore.collection('profissionais').doc(uid).set({
      'cidades': cidadesMap,
    }, SetOptions(merge: true));
  }

  // Carrega cidades selecionadas do usuário
  Future<List<CidadeModel>> carregarCidades(String uid) async {
    final doc = await _firestore.collection('profissionais').doc(uid).get();
    if (doc.exists && doc.data()?['cidades'] != null) {
      final List data = doc.data()!['cidades'];
      return data.map((c) => CidadeModel.fromMap(c)).toList();
    }
    return [];
  }

  // Busca cidades do estado de SP via API IBGE
  Future<List<String>> buscarCidadesSP() async {
    const url =
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/SP/municipios';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<String>((c) => c['nome'] as String).toList();
    } else {
      return [];
    }
  }
}
