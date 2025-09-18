import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jao_servico_profissional/controllers/perfil_controller.dart';
import 'package:jao_servico_profissional/models/perfil_model.dart';
import 'package:jao_servico_profissional/models/rodape.dart';
import 'package:jao_servico_profissional/cores.dart';
import 'package:jao_servico_profissional/repositories/perfil_repository.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage>
    with SingleTickerProviderStateMixin {
  final _formkey = GlobalKey<FormState>();
  final _controller = PerfilController(repository: PerfilRepository());
  bool _isEditing = false;
  bool _isLoading = true;
  bool _isSaving = false;

  final nomeController = TextEditingController();
  final detalhesController = TextEditingController();
  String? _fotoUrl;
  File? _imagemSelecionada;

  late final AnimationController _loaderController;
  late final Animation<double> _loaderAnimation;

  @override
  void initState() {
    super.initState();

    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loaderAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _loaderController, curve: Curves.easeInOut),
    );
    _loaderController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _loaderController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _loaderController.forward();
      }
    });

    carregarPerfil();
  }

  @override
  void dispose() {
    nomeController.dispose();
    detalhesController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  Future<void> carregarPerfil() async {
    setState(() => _isLoading = true);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final perfil = await _controller.carregarPerfil(uid);
    if (perfil != null) {
      setState(() {
        nomeController.text = perfil.nome!;
        detalhesController.text = perfil.detalhes!;
        _fotoUrl = perfil.fotoUrl;
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> salvarPerfil() async {
    if (_formkey.currentState!.validate()) {
      try {
        setState(() => _isSaving = true);
        _loaderController.forward();

        final uid = FirebaseAuth.instance.currentUser!.uid;

        String? fotoUrl = _fotoUrl;
        if (_imagemSelecionada != null) {
          fotoUrl =
              await _controller.uploadFotoPerfil(uid, _imagemSelecionada!);
        }

        final perfil = PerfilModel(
          nome: nomeController.text,
          detalhes: detalhesController.text,
          fotoUrl: fotoUrl ?? '',
        );

        await _controller.salvarPerfil(uid, perfil);

        setState(() {
          _isEditing = false;
          _fotoUrl = fotoUrl;
          _imagemSelecionada = null;
        });

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil salvo com sucesso')),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar o perfil: $e')),
        );
      } finally {
        setState(() => _isSaving = false);
        _loaderController.stop();
        _loaderController.reset();
      }
    }
  }

  Future<void> selecionarImagem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagemSelecionada = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.laranjaMuitoSuave,
      body: Stack(
        children: [
          SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formkey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Perfil",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Cores.azul,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Aqui você consegue acessar e editar suas informações",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16, color: Cores.preto),
                                  ),
                                  const SizedBox(height: 30),
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: _imagemSelecionada != null
                                          ? Image.file(_imagemSelecionada!,
                                              fit: BoxFit.cover)
                                          : (_fotoUrl != null &&
                                                  _fotoUrl!.isNotEmpty
                                              ? CachedNetworkImage(
                                                  imageUrl: _fotoUrl!,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Icon(Icons.error),
                                                )
                                              : Image.asset(
                                                  'assets/profissional.png',
                                                  fit: BoxFit.cover)),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: _isEditing ? selecionarImagem : null,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: _isEditing
                                            ? Cores.azul.withOpacity(0.1)
                                            : Cores.azul.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.add_a_photo,
                                            color: Cores.azul,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Alterar imagem",
                                            style: TextStyle(
                                              color: Cores.azul,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: () => Navigator.pushNamed(
                                              context, '/contatos'),
                                          child: _buildPerfilIcone(
                                              Icons.people, "Contatos \n"),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.pushNamed(
                                              context, '/certificados'),
                                          child: _buildPerfilIcone(
                                              Icons.school,
                                              "Certificados\nFormações"),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.pushNamed(
                                              context, '/cidades'),
                                          child: _buildPerfilIcone(
                                              Icons.location_on,
                                              "Cidades \n de atuação"),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.pushNamed(
                                              context, '/negocios'),
                                          child: _buildPerfilIcone(
                                              Icons.business_center, "Negócios\n"),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.pushNamed(
                                              context, '/habilidades'),
                                          child: _buildPerfilIcone(
                                              Icons.star, "Habilidades\n"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildTextField("Nome", nomeController),
                                  _buildTextField("Detalhes", detalhesController),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_isEditing) {
                                    salvarPerfil();
                                  }
                                  setState(() => _isEditing = !_isEditing);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Cores.laranja,
                                  side: BorderSide(color: Cores.azul, width: 2),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 12),
                                ),
                                child: Text(
                                  _isEditing ? "Salvar" : "Editar",
                                  style: TextStyle(color: Cores.azul, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
          // 🔽 Loader ao salvar
          IgnorePointer(
            ignoring: !_isSaving,
            child: AnimatedOpacity(
              opacity: _isSaving ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Cores.laranjaMuitoSuave.withOpacity(0.5),
                child: Center(
                  child: ScaleTransition(
                    scale: _loaderAnimation,
                    child: CircularProgressIndicator(
                      color: Cores.azul,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Rodape(),
    );
  }

  Widget _buildPerfilIcone(IconData icone, String texto) {
    return Column(
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: Cores.laranja,
            shape: BoxShape.circle,
            border: Border.all(color: Cores.azul, width: 2),
          ),
          child: Icon(icone, color: Cores.azul, size: 35),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              texto,
              textAlign: TextAlign.center,
              style: TextStyle(color: Cores.azul, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        readOnly: !_isEditing,
        style: TextStyle(
          color: _isEditing ? Cores.preto : Colors.grey[600],
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: _isEditing ? Cores.azul : Colors.grey[600],
          ),
          filled: true,
          fillColor: Cores.branco,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
