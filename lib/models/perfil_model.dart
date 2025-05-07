class PerfilModel {
  String? nome;
  String? email;
  String? detalhes;
  String? fotoUrl;

  PerfilModel({
    this.nome,
    this.email,
    this.detalhes,
    this.fotoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'detalhes': detalhes,
      'fotoUrl': fotoUrl,
    };
  }

  factory PerfilModel.fromMap(Map<String, dynamic> map) {
    return PerfilModel(
      nome: map['nome'],
      email: map['email'],
      detalhes: map['detalhes'],
      fotoUrl: map['fotoUrl'],
    );
  }
}
