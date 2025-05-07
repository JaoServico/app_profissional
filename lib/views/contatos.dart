import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/cores.dart';

class ContatosPage extends StatefulWidget {
  const ContatosPage({super.key});

  @override
  State<ContatosPage> createState() => _ContatosPageState();
}

class _ContatosPageState extends State<ContatosPage> {
  bool editando = false;

  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController siteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.laranjaMuitoSuave,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Contatos",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Cores.azul,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Cadastre e edite seus contatos e redes sociais aqui",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              _buildTextField("Whatsapp", whatsappController),
              _buildTextField("Telefone", telefoneController),
              _buildTextField("Email", emailController),
              _buildTextField("Facebook", facebookController),
              _buildTextField("Instagram", instagramController),
              _buildTextField("Linkedin", linkedinController),
              _buildTextField("Site", siteController),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          editando = !editando;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Cores.laranja,
                        side: BorderSide(color: Cores.azul, width: 2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                      ),
                      child: Text(
                        editando ? "Concluir" : "Editar",
                        style: TextStyle(
                          color: Cores.azul,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Cores.branco,
                        side: BorderSide(color: Cores.azul, width: 2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                      ),
                      child: Text(
                        "Voltar",
                        style: TextStyle(
                          color: Cores.azul,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        enabled: editando,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Cores.branco,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
