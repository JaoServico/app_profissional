import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/cores.dart';
import '../controllers/auth.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _repetirSenhaController = TextEditingController();

  bool _isLoading = false;
  bool _senhaVisivel = false;
  bool _repetirSenhaVisivel = false;

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
    _repetirSenhaController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
    bool showToggle = false,
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
        suffixIcon: showToggle
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Cores.azul,
                ),
                onPressed: toggleVisibility,
              )
            : null,
      ),
    );
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    _loaderController.forward();

    final erro = await AuthService()
        .signUp(email: _emailController.text, senha: _senhaController.text);

    if (!mounted) return;
    setState(() => _isLoading = false);
    _loaderController.stop();
    _loaderController.reset();

    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/loginPage');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro)),
      );
    }
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
                    "Cadastro",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Cores.branco,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Crie sua conta para acessar o aplicativo",
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
                            if (value == null || value.isEmpty) {
                              return "Digite seu email";
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return "E-mail inválido";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _senhaController,
                          labelText: "Senha",
                          obscureText: !_senhaVisivel,
                          showToggle: true,
                          toggleVisibility: () {
                            setState(() {
                              _senhaVisivel = !_senhaVisivel;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Digite sua senha";
                            }
                            if (value.length < 6) {
                              return "A senha deve ter no mínimo 6 caracteres";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _repetirSenhaController,
                          labelText: "Repetir senha",
                          obscureText: !_repetirSenhaVisivel,
                          showToggle: true,
                          toggleVisibility: () {
                            setState(() {
                              _repetirSenhaVisivel = !_repetirSenhaVisivel;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Repita sua senha";
                            }
                            if (value != _senhaController.text) {
                              return "As senhas não coincidem";
                            }
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
                          onPressed: _isLoading ? null : _cadastrar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Cores.branco,
                            side: BorderSide(color: Cores.azul),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                          ),
                          child: Text(
                            "Cadastrar",
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

          // Loader animado
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
