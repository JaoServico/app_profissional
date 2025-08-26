import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/perfil_model.dart';

class PerfilRepository {
  final _firestore = FirebaseFirestore.instance;

  // Recupera perfil do Firestore
  Future<PerfilModel?> getPerfil(String uid) async {
    final doc = await _firestore.collection('profissionais').doc(uid).get();

    if (!doc.exists) return null;
    return PerfilModel.fromMap(doc.data()!);
  }

  // Salva perfil no Firestore
  Future<void> savePerfil(String uid, PerfilModel perfil) async {
    await _firestore
        .collection('profissionais')
        .doc(uid)
        .set(perfil.toMap(), SetOptions(merge: true));
  }

  // Atualiza somente a foto do perfil
  Future<void> atualizarFotoUrl(String uid, String url) async {
    await _firestore.collection('profissionais').doc(uid).update({
      'fotoUrl': url,
    });
  }
}
