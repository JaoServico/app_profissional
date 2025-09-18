import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../controllers/contatos_controller.dart';
import '../models/contato_model.dart';
import '../cores.dart';

class ContatosPage extends StatefulWidget {
  const ContatosPage({super.key});

  @override
  State<ContatosPage> createState() => _ContatosPageState();
}

class _ContatosPageState extends State<ContatosPage>
    with SingleTickerProviderStateMixin {
  bool editando = false;

  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController siteController = TextEditingController();

  final whatsappMask = MaskTextInputFormatter(mask: '(##) #####-####');
  final telefoneMask = MaskTextInputFormatter(mask: '(##) ####-####');

  bool _isSaving = false;
  late final AnimationController _loaderController;
  late final Animation<double> _loaderAnimation;

  @override
  void initState() {
    super.initState();

    // Loader animation
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

    // Carregar contatos
    Future.microtask(() async {
      final controller = context.read<ContatosController>();
      await controller.carregarContatos();
      _preencherCampos(controller.contatos);
    });
  }

  @override
  void dispose() {
    _loaderController.dispose();
    whatsappController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    linkedinController.dispose();
    siteController.dispose();
    super.dispose();
  }

  void _preencherCampos(ContatoModel c) {
    whatsappController.text = c.whatsapp;
    telefoneController.text = c.telefone;
    emailController.text = c.email;
    facebookController.text = c.facebook;
    instagramController.text = c.instagram;
    linkedinController.text = c.linkedin;
    siteController.text = c.site;
  }

  Future<void> _salvarContatos() async {
    final controller = context.read<ContatosController>();
    final novo = ContatoModel(
      whatsapp: whatsappController.text,
      telefone: telefoneController.text,
      email: emailController.text,
      facebook: facebookController.text,
      instagram: instagramController.text,
      linkedin: linkedinController.text,
      site: siteController.text,
    );

    setState(() => _isSaving = true);
    _loaderController.forward();

    controller.atualizarContatos(novo);
    final sucesso = await controller.salvarContatos();

    _loaderController.stop();
    _loaderController.reset();
    setState(() => _isSaving = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sucesso ? "Contatos salvos com sucesso!" : "Erro ao salvar contatos.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ContatosController>();

    return Scaffold(
      backgroundColor: Cores.laranjaMuitoSuave,
      body: Stack(
        children: [
          SafeArea(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
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
                        const SizedBox(height: 8),
                        const Text(
                          "Cadastre e edite seus contatos e redes sociais aqui",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        _buildTextField("Whatsapp", whatsappController,
                            inputFormatters: [whatsappMask]),
                        _buildTextField("Telefone", telefoneController,
                            inputFormatters: [telefoneMask]),
                        _buildTextField("Email", emailController),
                        _buildTextField("Facebook", facebookController),
                        _buildTextField("Instagram", instagramController),
                        _buildTextField("Linkedin", linkedinController),
                        _buildTextField("Site", siteController),
                        const SizedBox(height: 80), // espaço antes dos botões
                        // Botões dentro do body
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isSaving
                                    ? null
                                    : () async {
                                        if (editando) {
                                          await _salvarContatos();
                                        }
                                        setState(() => editando = !editando);
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
                            const SizedBox(width: 20),
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
          // Loader
          IgnorePointer(
            ignoring: !_isSaving,
            child: AnimatedOpacity(
              opacity: _isSaving ? 1.0 : 0.0,
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

  Widget _buildTextField(String label, TextEditingController controller,
      {List<TextInputFormatter>? inputFormatters}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        enabled: editando,
        controller: controller,
        inputFormatters: inputFormatters,
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
