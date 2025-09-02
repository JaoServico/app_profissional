import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/certificado_model.dart';

class CertificadoRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<CertificadoModel>> getCertificados(String uid) async {
    final snapshot = await _firestore
        .collection('profissionais')
        .doc(uid)
        .collection('certificados')
        .get();

    return snapshot.docs
        .map((doc) => CertificadoModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> saveCertificados(String uid, List<CertificadoModel> certificados) async {
    final batch = _firestore.batch();
    final collectionRef = _firestore.collection('profissionais').doc(uid).collection('certificados');

    // Remove todos os antigos
    final snapshot = await collectionRef.get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    // Adiciona os novos
    for (var cert in certificados) {
      final docRef = collectionRef.doc();
      batch.set(docRef, cert.toMap());
    }

    await batch.commit();
  }
}
