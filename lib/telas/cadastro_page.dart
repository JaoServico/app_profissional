import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/cores.dart';
import '../servicos/auth.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _repetirSenhaController = TextEditingController();

  bool _isLoading = false;

  //Gera Textfields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            text: labelText,
            style: const TextStyle(color: Cores.preto, fontSize: 16),
            children: const [
              TextSpan(
                text: " *",
                style: TextStyle(color: Cores.vermelho, fontSize: 16),
              ),
            ],
          ),
        ),
        filled: true,
        fillColor: Cores.branco,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  //Funcão de cadastro
  Future<void> _cadastrar() async {
    if (_formkey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final sucesso = await AuthService()
          .signUp(email: _emailController.text, senha: _senhaController.text);

      setState(() => _isLoading = false);

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cadastro realizado com sucesso!"),
          ),
        );
        Navigator.pushNamed(context, '/loginPage');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro ao registrar."),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _repetirSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.laranjaMuitoSuave,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            Text(
              "Cadastro",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Cores.azul,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Crie sua conta para acessar o aplicativo",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Cores.preto),
            ),
            const SizedBox(
              height: 40,
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Digite seu email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTextField(
                    controller: _senhaController,
                    labelText: 'Senha',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Digite sua senha";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTextField(
                    controller: _repetirSenhaController,
                    labelText: 'Repetir senha',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Repita sua senha";
                      } else if (value != _senhaController.text) {
                        return "As senhas não coincidem";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _cadastrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Cores.laranja,
                      side: BorderSide(
                        color: Cores.azul,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(
                        color: Cores.azul,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
