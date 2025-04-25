import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/componentes/rodape.dart';
import 'package:jao_servico_profissional/cores.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool _isEditing = false;

  //Controladores TextFields
  TextEditingController nomeController =
      TextEditingController(text: "João Silva");
  TextEditingController emailController =
      TextEditingController(text: "joao@exemplo.com");
  TextEditingController detalhesController =
      TextEditingController(text: "Profissional com 10 anos de experiência...");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.laranjaMuitoSuave,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
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
                        onTap: () => Navigator.pushNamed(context, '/negocios'),
                        child: _buildPerfilIcone(
                            Icons.business_center, "Negócios\n")),
                    GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/habilidades'),
                        child: _buildPerfilIcone(Icons.star, "Habilidades\n")),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                //Formulário de informações
                _buildTextField("Nome", nomeController),
                _buildTextField("Email", emailController),
                _buildTextField("Detalhes", detalhesController),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(
                            () {
                              _isEditing = !_isEditing;
                            },
                          );
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
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
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
