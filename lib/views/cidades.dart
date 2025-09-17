import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cidade_controller.dart';
import '../cores.dart';

class CidadesPage extends StatefulWidget {
  const CidadesPage({super.key});

  @override
  State<CidadesPage> createState() => _CidadesPageState();
}

class _CidadesPageState extends State<CidadesPage> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _dropdownOverlay;

  @override
  void initState() {
    super.initState();

    // Inicializa controller e carrega cidades
    final controller = context.read<CidadeController>();
    Future.microtask(() => controller.init());

    // Listener para mostrar/ocultar dropdown
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showDropdown();
      } else {
        _removeDropdown();
      }
    });
  }

  @override
  void dispose() {
    _removeDropdown();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showDropdown() {
    _removeDropdown();
    _dropdownOverlay = _createDropdownOverlay();
    Overlay.of(context).insert(_dropdownOverlay!);
  }

  void _removeDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  void _updateFilter(String text) {
    setState(() {}); // rebuild para filtrar lista
    if (_dropdownOverlay != null) {
      _removeDropdown();
      _dropdownOverlay = _createDropdownOverlay();
      Overlay.of(context).insert(_dropdownOverlay!);
    }
  }

  OverlayEntry _createDropdownOverlay() {
    final controller = context.read<CidadeController>();
    final size = context.size ?? Size.zero;

    final filter = _searchController.text.toLowerCase();
    final filteredCidades = controller.cidadesDisponiveis
        .where((c) => c.toLowerCase().contains(filter))
        .toList();

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
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: filteredCidades.length,
                itemBuilder: (context, index) {
                  final cidade = filteredCidades[index];
                  final isSelected = controller.cidadesSelecionadas
                      .any((c) => c.nome == cidade);

                  return ListTile(
                    title: Text(cidade),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      if (isSelected) {
                        controller.removerCidade(cidade);
                      } else {
                        controller.adicionarCidade(cidade);
                      }
                      _searchController.clear();
                      _removeDropdown();
                      _focusNode.unfocus();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CidadeController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Scaffold(
            backgroundColor: Cores.laranjaMuitoSuave,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return GestureDetector(
          onTap: () => _focusNode.unfocus(),
          child: Scaffold(
            backgroundColor: Cores.laranjaMuitoSuave,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Cidades de atuação',
                      style: TextStyle(
                        color: Cores.azul,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Adicione e edite aqui suas cidades de atuação',
                      style: TextStyle(color: Cores.preto, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    CompositedTransformTarget(
                      link: _layerLink,
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: _updateFilter,
                        decoration: InputDecoration(
                          labelText: 'Buscar cidade',
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
                      children: controller.cidadesSelecionadas
                          .map(
                            (c) => Chip(
                              label: Text(c.nome),
                              backgroundColor: Cores.laranjaSuave,
                              labelStyle: TextStyle(color: Cores.azul),
                              deleteIconColor: Cores.azul,
                              onDeleted: () => controller.removerCidade(c.nome),
                            ),
                          )
                          .toList(),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller.salvarCidades();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Cidades salvas com sucesso!')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Cores.laranja,
                              side: BorderSide(color: Cores.azul, width: 2),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 32),
                            ),
                            child: Text(
                              "Salvar",
                              style: TextStyle(color: Cores.azul, fontSize: 16),
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
                                  vertical: 12, horizontal: 32),
                            ),
                            child: Text(
                              "Voltar",
                              style: TextStyle(color: Cores.azul, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
