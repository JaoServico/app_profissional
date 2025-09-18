import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/cores.dart';
import 'package:jao_servico_profissional/controllers/auth.dart';

class EsqueceuSenha extends StatefulWidget {
  const EsqueceuSenha({super.key});

  @override
  State<EsqueceuSenha> createState() => _EsqueceuSenhaState();
}

class _EsqueceuSenhaState extends State<EsqueceuSenha>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  Future<void> _enviarLink() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      _loaderController.forward();

      final sucesso = await AuthService()
          .sendPasswordResetEmail(email: _emailController.text);

      setState(() => _isLoading = false);
      _loaderController.stop();
      _loaderController.reset();

      final mensagem = sucesso
          ? "Link de recuperação enviado para o email informado."
          : "Erro ao enviar o link. Verifique o email informado";

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );

      if (sucesso) {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: _emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Digite o email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'E-mail inválido';
        }
        return null;
      },
      decoration: InputDecoration(
        label: RichText(
          text: const TextSpan(
            text: "Email",
            style: TextStyle(color: Cores.preto, fontSize: 16),
            children: [
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
      backgroundColor: Cores.laranja,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Image.asset(
                    'assets/logo.png',
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Esqueci a senha",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Cores.branco,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Digite seu email e enviaremos um link de recuperação.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, color: Cores.branco.withOpacity(0.9)),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: _buildTextField(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _enviarLink,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Cores.branco,
                            side: BorderSide(color: Cores.azul),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                          ),
                          child: Text(
                            "Enviar link",
                            style: TextStyle(color: Cores.azul, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Cores.branco,
                            side: BorderSide(color: Cores.azul),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                          ),
                          child: Text(
                            "Voltar",
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

          // 🔽 Loader animado
          IgnorePointer(
            ignoring: !_isLoading,
            child: AnimatedOpacity(
              opacity: _isLoading ? 1.0 : 0.0,
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
    );
  }
}
