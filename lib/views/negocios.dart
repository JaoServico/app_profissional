import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import '../controllers/negocio_controller.dart';
import '../models/negocio_model.dart';
import '../cores.dart';

class NegociosPage extends StatefulWidget {
  const NegociosPage({super.key});

  @override
  State<NegociosPage> createState() => _NegociosPageState();
}

class _NegociosPageState extends State<NegociosPage> {
  bool editando = false;

  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();

  final cepMask = MaskTextInputFormatter(mask: '#####-###');
  final cnpjMask = MaskTextInputFormatter(mask: '##.###.###/####-##');

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final controller = context.read<NegocioController>();
      await controller.carregarNegocio();
      _preencherCampos(controller.negocio);
    });
  }

  void _preencherCampos(NegocioModel n) {
    enderecoController.text = n.endereco;
    numeroController.text = n.numero;
    bairroController.text = n.bairro;
    complementoController.text = n.complemento;
    cepController.text = n.cep;
    cidadeController.text = n.cidade;
    cnpjController.text = n.cnpj;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<NegocioController>();

    return Scaffold(
      backgroundColor: Cores.laranjaMuitoSuave,
      body: SafeArea(
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Negócios",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Cores.azul,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Cadastre e edite aqui os dados do seu negócio ou estabelecimento",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    _buildTextField("Endereço", enderecoController),
                    _buildTextField("Número", numeroController),
                    _buildTextField("Bairro", bairroController),
                    _buildTextField("Complemento", complementoController),
                    _buildTextField("CEP", cepController,
                        inputFormatters: [cepMask]),
                    _buildTextField("Cidade", cidadeController),
                    _buildTextField("CNPJ", cnpjController,
                        inputFormatters: [cnpjMask]),
                    const SizedBox(height: 80), // espaço pro rodapé
                  ],
                ),
              ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if (editando) {
                      final novo = NegocioModel(
                        endereco: enderecoController.text,
                        numero: numeroController.text,
                        bairro: bairroController.text,
                        complemento: complementoController.text,
                        cep: cepController.text,
                        cidade: cidadeController.text,
                        cnpj: cnpjController.text,
                      );

                      controller.atualizarNegocio(novo);
                      final sucesso = await controller.salvarNegocio();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            sucesso
                                ? "Dados do negócio salvos com sucesso!"
                                : "Erro ao salvar dados do negócio.",
                          ),
                        ),
                      );
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
        ),
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
