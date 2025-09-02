import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jao_servico_profissional/cores.dart';
import '../controllers/certificado_controller.dart';
import '../repositories/certificado_repository.dart';
import '../models/rodape.dart';

class CertificadosPage extends StatefulWidget {
  const CertificadosPage({super.key});

  @override
  State<CertificadosPage> createState() => _CertificadosPageState();
}

class _CertificadosPageState extends State<CertificadosPage> {
  late CertificadoController controller;

  @override
  void initState() {
    super.initState();
    controller = CertificadoController(repository: CertificadoRepository());
    final uid = FirebaseAuth.instance.currentUser!.uid;
    controller.carregarCertificados(uid);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<CertificadoController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: Cores.laranjaMuitoSuave,
            body: SafeArea(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            "Certificados e Formações",
                            style: TextStyle(
                              fontSize: 24,
                              color: Cores.azul,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Cadastre ou edite seus certificados e formações",
                            style: TextStyle(fontSize: 16, color: Cores.preto),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.certificados.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Cores.vermelho),
                                              onPressed: () => controller.removerCertificado(index),
                                            ),
                                          ],
                                        ),
                                        TextField(
                                          controller: controller.controllersNome[index],
                                          decoration: const InputDecoration(
                                            labelText: 'Nome do Certificado',
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                          ),
                                          maxLines: null,
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controller.controllersData[index],
                                          decoration: const InputDecoration(
                                            labelText: 'Data de Conclusão',
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: controller.adicionarCertificado,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Cores.laranja,
                                    foregroundColor: Cores.azul,
                                    side: BorderSide(color: Cores.azul, width: 2),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: const Text("Adicionar Certificado", style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final uid = FirebaseAuth.instance.currentUser!.uid;
                                    await controller.salvarCertificados(uid);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Certificados salvos com sucesso')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Cores.laranja,
                                    side: BorderSide(color: Cores.azul, width: 2),
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                  ),
                                  child: Text("Salvar", style: TextStyle(color: Cores.azul, fontSize: 16)),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Cores.branco,
                                    side: BorderSide(color: Cores.azul, width: 2),
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                  ),
                                  child: Text("Voltar", style: TextStyle(color: Cores.azul, fontSize: 16)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
            bottomNavigationBar: const Rodape(),
          );
        },
      ),
    );
  }
}
