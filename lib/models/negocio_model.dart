class NegocioModel {
  final String endereco;
  final String numero;
  final String bairro;
  final String complemento;
  final String cep;
  final String cidade;
  final String cnpj;

  NegocioModel({
    required this.endereco,
    required this.numero,
    required this.bairro,
    required this.complemento,
    required this.cep,
    required this.cidade,
    required this.cnpj,
  });

  Map<String, dynamic> toMap() {
    return {
      'endereco': endereco,
      'numero': numero,
      'bairro': bairro,
      'complemento': complemento,
      'cep': cep,
      'cidade': cidade,
      'cnpj': cnpj,
    };
  }

  factory NegocioModel.fromMap(Map<String, dynamic> map) {
    return NegocioModel(
      endereco: map['endereco'] ?? '',
      numero: map['numero'] ?? '',
      bairro: map['bairro'] ?? '',
      complemento: map['complemento'] ?? '',
      cep: map['cep'] ?? '',
      cidade: map['cidade'] ?? '',
      cnpj: map['cnpj'] ?? '',
    );
  }

  static NegocioModel vazio() {
    return NegocioModel(
      endereco: '',
      numero: '',
      bairro: '',
      complemento: '',
      cep: '',
      cidade: '',
      cnpj: '',
    );
  }
}
