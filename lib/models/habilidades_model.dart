class Habilidade {
  final String id;
  final String nome;

  Habilidade({required this.id, required this.nome});

  factory Habilidade.fromFirestore(Map<String, dynamic> data, String id) {
    return Habilidade(
      id: id,
      nome: data['nome'] ?? '',
    );
  }
}
