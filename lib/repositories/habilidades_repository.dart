import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habilidades_model.dart';

class HabilidadesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Habilidades disponíveis globalmente
  Future<List<Habilidade>> getHabilidades() async {
    final snapshot = await _firestore.collection('habilidades').get();
    return snapshot.docs
        .map((doc) => Habilidade.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  /// Salvar habilidades selecionadas do profissional em coleção própria
  Future<void> salvarHabilidadesSelecionadas(
      String uid, List<String> habilidades) async {
    final ref = _firestore
        .collection('profissionais')
        .doc(uid)
        .collection('habilidades');

    // remove todas antes de salvar de novo (garante consistência)
    final snapshot = await ref.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    for (var habilidade in habilidades) {
      await ref.add({'nome': habilidade});
    }
  }

  /// Carregar habilidades já selecionadas pelo profissional
  Future<List<String>> carregarHabilidadesSelecionadas(String uid) async {
    final snapshot = await _firestore
        .collection('profissionais')
        .doc(uid)
        .collection('habilidades')
        .get();

    return snapshot.docs.map((doc) => doc['nome'] as String).toList();
  }
}
