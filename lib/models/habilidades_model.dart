class HabilidadesModel {
  final String id;
  final String nome;

  HabilidadesModel({required this.id, required this.nome});

  factory HabilidadesModel.fromFirestore(Map<String, dynamic> data, String id) {
    return HabilidadesModel(
      id: id,
      nome: data['nome'] ?? '',
    );
  }
}
