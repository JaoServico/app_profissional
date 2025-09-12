import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/habilidades_controller.dart';
import '../cores.dart';

class HabilidadesPage extends StatefulWidget {
  const HabilidadesPage({super.key});

  @override
  State<HabilidadesPage> createState() => _HabilidadesPageState();
}

class _HabilidadesPageState extends State<HabilidadesPage> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _dropdownOverlay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<HabilidadesController>();
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        controller.carregarHabilidades(uid);
      }
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _mostrarDropdown();
      else _removerDropdown();
    });
  }

  @override
  void dispose() {
    _removerDropdown();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _mostrarDropdown() {
    _removerDropdown();
    final controller = context.read<HabilidadesController>();
    if (controller.habilidades.isEmpty) return; // Evita overlay vazio
    controller.filtrarHabilidades('');
    _dropdownOverlay = _criarDropdownOverlay();
    if (_dropdownOverlay != null) Overlay.of(context)?.insert(_dropdownOverlay!);
  }

  void _removerDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  void _atualizarFiltro(String texto) {
    final controller = context.read<HabilidadesController>();
    controller.filtrarHabilidades(texto);
    if (_dropdownOverlay != null) {
      _removerDropdown();
      _dropdownOverlay = _criarDropdownOverlay();
      if (_dropdownOverlay != null) Overlay.of(context)?.insert(_dropdownOverlay!);
    }
  }

  OverlayEntry? _criarDropdownOverlay() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    final size = renderBox.size;

    final controller = context.read<HabilidadesController>();
    final habilidadesFiltradas = controller.habilidadesFiltradas;
    if (habilidadesFiltradas.isEmpty) return null;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width - 40,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(8),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: habilidadesFiltradas.length,
              itemBuilder: (context, index) {
                final habilidade = habilidadesFiltradas[index];
                return ListTile(
                  title: Text(habilidade),
                  onTap: () {
                    controller.adicionarHabilidadeSelecionada(habilidade);
                    _searchController.clear();
                    _removerDropdown();
                    _focusNode.unfocus();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        backgroundColor: Cores.laranjaMuitoSuave,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Consumer<HabilidadesController>(
              builder: (context, controller, _) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Habilidades',
                        style: TextStyle(
                          color: Cores.azul,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Adicione e edite suas habilidades aqui',
                        style: TextStyle(
                          color: Cores.preto,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CompositedTransformTarget(
                        link: _layerLink,
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          onChanged: _atualizarFiltro,
                          decoration: InputDecoration(
                            labelText: 'Buscar habilidade',
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.habilidadesSelecionadas
                            .map(
                              (hab) => Chip(
                                label: Text(hab),
                                backgroundColor: Cores.laranjaSuave,
                                labelStyle: TextStyle(color: Cores.azul),
                                deleteIconColor: Cores.azul,
                                onDeleted: () => controller.removerHabilidadeSelecionada(hab),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final uid = FirebaseAuth.instance.currentUser?.uid;
                                if (uid != null) {
                                  final sucesso = await controller.salvarHabilidades(uid);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        sucesso
                                            ? "Habilidades salvas com sucesso!"
                                            : "Erro ao salvar habilidades.",
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Cores.laranja,
                                side: BorderSide(color: Cores.azul, width: 2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 12),
                              ),
                              child: Text(
                                "Salvar",
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
