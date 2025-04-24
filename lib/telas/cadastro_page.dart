import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/cores.dart';

class CadastroPage extends StatelessWidget {
  const CadastroPage({super.key});

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
            _buildTextField("Email"),
            _buildTextField("Senha", isPassword: true),
            _buildTextField("Repita a senha", isPassword: true),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.pushNamed(
                      //     context, '/telaConfirmacaoIndicacao');
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
