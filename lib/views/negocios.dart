import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/cores.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.laranjaMuitoSuave,
      body: SafeArea(
        child: Padding(
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
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Cadastre e edite aqui os dados do seu negócio ou estabelecimento",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              _buildTextField("Endereço", enderecoController),
              _buildTextField("Número", numeroController),
              _buildTextField("Bairro", bairroController),
              _buildTextField("Complemento", complementoController),
              _buildTextField("CEP", cepController),
              _buildTextField("Cidade", cidadeController),
              _buildTextField("CNPJ", cnpjController),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          editando = !editando;
                        });
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
                  const SizedBox(
                    width: 20,
                  ),
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
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        enabled: editando,
        controller: controller,
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
