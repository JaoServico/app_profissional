import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cidade_model.dart';

class CidadeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  // Salva cidades selecionadas do usuário em subcoleção 'cidades'
  Future<void> salvarCidades(String uid, List<CidadeModel> cidades) async {
    final cidadesCollection =
        _firestore.collection('profissionais').doc(uid).collection('cidades');

    // Primeiro, removemos os documentos existentes para evitar duplicidade
    final snapshot = await cidadesCollection.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }

    // Agora adicionamos cada cidade como um novo documento
    for (final cidade in cidades) {
      await cidadesCollection.add(cidade.toMap());
    }
  }

  // Carrega cidades selecionadas do usuário da subcoleção
  Future<List<CidadeModel>> carregarCidades(String uid) async {
    final cidadesCollection =
        _firestore.collection('profissionais').doc(uid).collection('cidades');

    final snapshot = await cidadesCollection.get();
    return snapshot.docs.map((doc) => CidadeModel.fromMap(doc.data())).toList();
  }
}
