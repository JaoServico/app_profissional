class PerfilModel {
  String? nome;
  String? detalhes;
  String? fotoUrl;

  PerfilModel({
    this.nome,
    this.detalhes,
    this.fotoUrl,
  });

  PerfilModel copyWith({
    String? nome,
    String? detalhes,
    String? fotoUrl,
  }) {
    return PerfilModel(
      nome: nome ?? this.nome,
      detalhes: detalhes ?? this.detalhes,
      fotoUrl: fotoUrl ?? this.fotoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'detalhes': detalhes,
      'fotoUrl': fotoUrl,
    };
  }

  factory PerfilModel.fromMap(Map<String, dynamic> map) {
    return PerfilModel(
      nome: map['nome'],
      detalhes: map['detalhes'],
      fotoUrl: map['fotoUrl'],
    );
  }
}
