import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/cores.dart';
import 'package:jao_servico_profissional/servicos/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final sucesso = await AuthService().signIn(
        email: _emailController.text,
        senha: _senhaController.text,
      );

      setState(() => _isLoading = false);

      if (sucesso) {
        Navigator.pushNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Erro ao fazer login. Verifique os dados")),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  //Metodo para criar os TextFormFields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
    bool obscureText = false,
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
              "Login",
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
              "Entre no app para cadastrar seu serviços",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Cores.preto),
            ),
            const SizedBox(
              height: 40,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _emailController,
                    labelText: "Email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Digite o email";
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTextField(
                    controller: _senhaController,
                    labelText: "Senha",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Digite a senha";
                      }
                      if (value.length < 6) {
                        return "A senha deve ter no mínimo 6 caracteres";
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
                    onPressed: _isLoading ? null : _login,
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
                      "Entrar",
                      style: TextStyle(
                        color: Cores.azul,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/esqueceuSenha');
              },
              child: Text(
                "Esqueci a senha",
                style: TextStyle(
                  color: Cores.azul,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/cadastroPage');
              },
              child: Text(
                "Criar conta",
                style: TextStyle(
                  color: Cores.azul,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
