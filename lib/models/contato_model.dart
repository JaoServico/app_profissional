class ContatoModel {
  String whatsapp;
  String telefone;
  String email;
  String facebook;
  String instagram;
  String linkedin;
  String site;

  ContatoModel({
    this.whatsapp = '',
    this.telefone = '',
    this.email = '',
    this.facebook = '',
    this.instagram = '',
    this.linkedin = '',
    this.site = '',
  });

  Map<String, dynamic> toMap() => {
        'whatsapp': whatsapp,
        'telefone': telefone,
        'email': email,
        'facebook': facebook,
        'instagram': instagram,
        'linkedin': linkedin,
        'site': site,
      };

  factory ContatoModel.fromMap(Map<String, dynamic> map) => ContatoModel(
        whatsapp: map['whatsapp'] ?? '',
        telefone: map['telefone'] ?? '',
        email: map['email'] ?? '',
        facebook: map['facebook'] ?? '',
        instagram: map['instagram'] ?? '',
        linkedin: map['linkedin'] ?? '',
        site: map['site'] ?? '',
      );
}
