import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/cores.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
            _buildTextField("Email"),
            _buildTextField("Senha", isPassword: true),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
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

  Widget _buildTextField(String label, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          label: RichText(
            text: TextSpan(
              text: label,
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
      ),
    );
  }
}
