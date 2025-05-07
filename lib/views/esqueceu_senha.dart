import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/cores.dart';
import 'package:jao_servico_profissional/controllers/auth.dart';

class EsqueceuSenha extends StatefulWidget {
  const EsqueceuSenha({super.key});

  @override
  State<EsqueceuSenha> createState() => _EsqueceuSenhaState();
}

class _EsqueceuSenhaState extends State<EsqueceuSenha> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _enviarLink() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final sucesso = await AuthService()
          .sendPasswordResetEmail(email: _emailController.text);
      setState(() => _isLoading = false);

      final mensagem = sucesso
          ? "Link de recuperação enviado para o email informado."
          : "Erro ao enviar o link. Verifique o email informado";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );

      if (sucesso && context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
              "Esqueci a senha",
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
              "Digite seu email e a solicitação para redefinir a senha será enviada no seu email",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Cores.preto),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    label: RichText(
                      text: const TextSpan(
                        text: "Email",
                        style: TextStyle(color: Cores.preto, fontSize: 16),
                        children: [
                          TextSpan(
                            text: " *",
                            style:
                                TextStyle(color: Cores.vermelho, fontSize: 16),
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
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Informe um email válido.';
                    if (!value.contains('@'))
                      return 'Formato de email inválido.';
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _enviarLink,
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
                      "Enviar",
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
