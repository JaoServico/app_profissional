import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/cores.dart';
import 'package:jao_servico_profissional/controllers/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isLoading = false;
  bool _senhaVisivel = false;
  final _formKey = GlobalKey<FormState>();

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
    _senhaController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      _loaderController.forward();

      final sucesso = await AuthService().signIn(
        email: _emailController.text,
        senha: _senhaController.text,
      );

      setState(() => _isLoading = false);
      _loaderController.stop();
      _loaderController.reset();

      if (sucesso) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Erro ao fazer login. Verifique os dados")),
        );
      }
    }
  }

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
        suffixIcon: obscureText
            ? IconButton(
                icon: Icon(
                  _senhaVisivel ? Icons.visibility_off : Icons.visibility,
                  color: Cores.azul,
                ),
                onPressed: () {
                  setState(() {
                    _senhaVisivel = !_senhaVisivel;
                  });
                },
              )
            : null,
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
                    "Login",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Cores.branco,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Entre no app para cadastrar seus serviços",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, color: Cores.branco.withOpacity(0.9)),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _emailController,
                          labelText: "Email",
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return "Digite o email";
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'E-mail inválido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _senhaController,
                          labelText: "Senha",
                          obscureText: !_senhaVisivel,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return "Digite a senha";
                            if (value.length < 6)
                              return "A senha deve ter no mínimo 6 caracteres";
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Cores.branco,
                            side: BorderSide(color: Cores.azul),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                          ),
                          child: Text(
                            "Entrar",
                            style: TextStyle(color: Cores.azul, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/esqueceuSenha');
                    },
                    child: const Text(
                      "Esqueci a senha",
                      style: TextStyle(
                        color: Cores.branco,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/cadastroPage');
                    },
                    child: const Text(
                      "Criar conta",
                      style: TextStyle(
                        color: Cores.branco,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔽 Loader
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
