import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/perfil_model.dart';

class PerfilRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<PerfilModel?> getPerfil(String uid) async {
    final snapshot = await _firestore
        .collection('profissionais')
        .doc(uid)
        .collection('perfil')
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return PerfilModel.fromMap(snapshot.docs.first.data());
  }

  Future<void> savePerfil(String uid,PerfilModel perfil) async {
    await _firestore
        .collection('profissionais')
        .doc(uid)
        .collection('perfil')
        .doc('dados')
        .set(perfil.toMap());
  }
}
