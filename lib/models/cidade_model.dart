class CidadeModel {
  final String nome;

  CidadeModel({required this.nome});

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
    };
  }

  factory CidadeModel.fromMap(Map<String, dynamic> map) {
    return CidadeModel(
      nome: map['nome'] ?? '',
    );
  }
}
