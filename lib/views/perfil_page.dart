import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

class _PerfilPageState extends State<PerfilPage> {
  final _formkey = GlobalKey<FormState>();
  final _controller = PerfilController(repository: PerfilRepository());
  bool _isEditing = false;

  final nomeController = TextEditingController();
  final detalhesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarPerfil();
  }

  Future<void> carregarPerfil() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final perfil = await _controller.carregarPerfil(uid);
    if (perfil != null) {
      setState(() {
        nomeController.text = perfil.nome!;
        detalhesController.text = perfil.detalhes!;
      });
    }
  }

  Future<void> salvarPerfil() async {
    if (_formkey.currentState!.validate()) {
      try {
        final uid = FirebaseAuth.instance.currentUser!.uid;
        final perfil = PerfilModel(
          nome: nomeController.text,
          detalhes: detalhesController.text,
          fotoUrl: '',
        );

        await _controller.salvarPerfil(uid, perfil);

        setState(() {
          _isEditing = false;
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.laranjaMuitoSuave,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const SizedBox(
                  //   height: 40,
                  // ),
                  Text(
                    "Perfil",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Cores.azul,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Aqui você consegue acessar e editar suas informações",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Cores.preto),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //Foto de Perfil
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                          image: AssetImage('assets/profissional.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Cores.azul.withOpacity(0.1),
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
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Alterar imagem",
                            style: TextStyle(color: Cores.azul, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/contatos'),
                        child: _buildPerfilIcone(Icons.people, "Contatos \n"),
                      ),
                      GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/certificados'),
                          child: _buildPerfilIcone(
                              Icons.school, "Certificados\nFormações")),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/cidades'),
                        child: _buildPerfilIcone(
                            Icons.location_on, "Cidades \n de atuação"),
                      ),
                      GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/negocios'),
                          child: _buildPerfilIcone(
                              Icons.business_center, "Negócios\n")),
                      GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/habilidades'),
                          child:
                              _buildPerfilIcone(Icons.star, "Habilidades\n")),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Formulário de informações
                  _buildTextField("Nome", nomeController),
                  _buildTextField("Detalhes", detalhesController),
                  const SizedBox(
                    height: 10,
                  ),
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
                            side: BorderSide(
                              color: Cores.azul,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                          ),
                          child: Text(
                            _isEditing ? "Concluir" : "Editar",
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
        ),
      ),
      bottomNavigationBar: const Rodape(),
    );
  }

  //Funcao prar criar o carrossel de itens
  Widget _buildPerfilIcone(IconData icone, String texto) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Cores.azul.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icone,
            color: Cores.azul,
            size: 30,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          texto,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Cores.azul,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  //Funcao para os TextFields
  Widget _buildTextField(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        readOnly: !_isEditing, // Desbloqueia quando esta no modo de edicao
        decoration: InputDecoration(
          labelText: label,
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
