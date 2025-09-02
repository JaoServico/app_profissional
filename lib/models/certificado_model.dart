class CertificadoModel {
  String nome;
  String data;

  CertificadoModel({required this.nome, required this.data});

  Map<String, dynamic> toMap() => {
        'nome': nome,
        'data': data,
      };

  factory CertificadoModel.fromMap(Map<String, dynamic> map) => CertificadoModel(
        nome: map['nome'] ?? '',
        data: map['data'] ?? '',
      );
}
