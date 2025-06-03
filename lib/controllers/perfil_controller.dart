import '../repositories/perfil_repository.dart';
import '../models/perfil_model.dart';

class PerfilController {
  final PerfilRepository repository;

  PerfilController({required this.repository});

  Future<PerfilModel?> carregarPerfil(String uid) async {
    return await repository.getPerfil(uid);
  }

  Future<void> salvarPerfil(String uid, PerfilModel perfil) async {
    await repository.savePerfil(uid, perfil);
  }

  Future<void> atualizarFoto(String uid, String url) async {
    await repository.atualizarFotoUrl(uid, url);
  }
}
