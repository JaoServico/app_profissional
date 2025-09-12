import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/negocio_model.dart';

class NegocioRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<NegocioModel?> carregarNegocio() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _db.collection('profissionais').doc(uid).collection('negocios').doc('dados').get();

    if (doc.exists) {
      return NegocioModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<bool> salvarNegocio(NegocioModel negocio) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return false;

      await _db.collection('profissionais').doc(uid).collection('negocios').doc('dados').set(negocio.toMap());
      return true;
    } catch (e) {
      print("Erro ao salvar negócio: $e");
      return false;
    }
  }
}
