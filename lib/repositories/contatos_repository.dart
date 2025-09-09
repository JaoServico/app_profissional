import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contato_model.dart';

class ContatosRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ContatoModel> carregarContatos(String uid) async {
    final doc = await _firestore
        .collection('profissionais')
        .doc(uid)
        .collection('contatos')
        .doc('info')
        .get();

    if (doc.exists && doc.data() != null) {
      return ContatoModel.fromMap(doc.data()!);
    }
    return ContatoModel(); // retorna vazio se não existir
  }

  Future<void> salvarContatos(String uid, ContatoModel contatos) async {
    await _firestore
        .collection('profissionais')
        .doc(uid)
        .collection('contatos')
        .doc('info')
        .set(contatos.toMap());
  }
}
