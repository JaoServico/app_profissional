import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jao_servico_profissional/cores.dart';
import '../controllers/certificado_controller.dart';
import '../repositories/certificado_repository.dart';

class CertificadosPage extends StatefulWidget {
  const CertificadosPage({super.key});

  @override
  State<CertificadosPage> createState() => _CertificadosPageState();
}

class _CertificadosPageState extends State<CertificadosPage>
    with SingleTickerProviderStateMixin {
  late CertificadoController controller;
  bool _isSaving = false;

  late final AnimationController _loaderController;
  late final Animation<double> _loaderAnimation;

  @override
  void initState() {
    super.initState();
    controller = CertificadoController(repository: CertificadoRepository());
    final uid = FirebaseAuth.instance.currentUser!.uid;
    controller.carregarCertificados(uid);

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
  }

  @override
  void dispose() {
    _loaderController.dispose();
    for (var c in controller.controllersNome) c.dispose();
    for (var c in controller.controllersData) c.dispose();
    super.dispose();
  }

  Future<void> _salvarCertificados() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  setState(() => _isSaving = true);
  _loaderController.forward();

  await controller.salvarCertificados(uid);

  _loaderController.stop();
  _loaderController.reset();
  setState(() => _isSaving = false);

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Certificados salvos com sucesso'),
      behavior: SnackBarBehavior.floating, // previne crash
      margin: EdgeInsets.zero,              // ocupa toda a largura
      shape: RoundedRectangleBorder(        // sem bordas arredondadas
        borderRadius: BorderRadius.zero,
      ),
      duration: Duration(seconds: 3),       // desaparece mais suave
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<CertificadoController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: Cores.laranjaMuitoSuave,
            body: Stack(
              children: [
                SafeArea(
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
                                style:
                                    TextStyle(fontSize: 16, color: Cores.preto),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: controller.certificados.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.delete,
                                                      color: Cores.vermelho),
                                                  onPressed: () =>
                                                      controller.removerCertificado(
                                                          index),
                                                ),
                                              ],
                                            ),
                                            TextField(
                                              controller:
                                                  controller.controllersNome[index],
                                              decoration: const InputDecoration(
                                                labelText:
                                                    'Nome do Certificado',
                                                filled: true,
                                                fillColor: Colors.white,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                              ),
                                              maxLines: null,
                                            ),
                                            const SizedBox(height: 10),
                                            TextField(
                                              controller:
                                                  controller.controllersData[index],
                                              decoration: const InputDecoration(
                                                labelText: 'Data de Conclusão',
                                                filled: true,
                                                fillColor: Colors.white,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
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
                                      onPressed: _isSaving
                                          ? null
                                          : controller.adicionarCertificado,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Cores.laranja,
                                        foregroundColor: Cores.azul,
                                        side: BorderSide(
                                            color: Cores.azul, width: 2),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                      child: const Text(
                                        "Adicionar Certificado",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed:
                                          _isSaving ? null : _salvarCertificados,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Cores.laranja,
                                        side: BorderSide(
                                            color: Cores.azul, width: 2),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 12),
                                      ),
                                      child: Text(
                                        "Salvar",
                                        style: TextStyle(
                                            color: Cores.azul, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Cores.branco,
                                        side: BorderSide(
                                            color: Cores.azul, width: 2),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 12),
                                      ),
                                      child: Text("Voltar",
                                          style: TextStyle(
                                              color: Cores.azul, fontSize: 16)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ),

                // 🔽 Loader
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
        },
      ),
    );
  }
}
