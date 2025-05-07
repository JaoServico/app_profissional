import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/cores.dart';

class CidadesPage extends StatefulWidget {
  const CidadesPage({super.key});

  @override
  State<CidadesPage> createState() => _CidadesPageState();
}

class _CidadesPageState extends State<CidadesPage> {
  final LayerLink _layerLink =
      LayerLink(); //Usado prar posicionar o dropdown ao campo
  final TextEditingController _searchController =
      TextEditingController(); //Controla o texto digitado
  final FocusNode _focusNode = FocusNode(); //Controla o foco do Textfield

  //Lista de cidades disponiveis
  final List<String> todasCidades = [
    'Tupã',
    'Herculândia',
    'Iacri',
    'Bastos',
    'Marilia',
    'Oriente',
    'Parnaso',
  ];

  //Cidades filtradas (com na base na busca)
  List<String> cidadesFiltradas = [];

  //Cidades que o usuário selecionou
  List<String> cidadesSelecionadas = [];

  //Referencia que o usuário selecionou
  OverlayEntry? _dropdownOverlay;

  @override
  void initState() {
    super.initState();
    //Listener que mostra ou esconde o dropwdown dependendo do foco
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _mostrarDropdown();
      } else {
        _removerDropdown();
      }
    });
  }

  @override
  void dispose() {
    //Remove e limpa tudo ao sair da tela
    _removerDropdown();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _mostrarDropdown() {
    _removerDropdown(); //Garante que não exista outro overlay antes
    cidadesFiltradas = todasCidades; //Mostra tudo inicialmente
    _dropdownOverlay = _criarDropdownOverlay(); //Criar overlay
    Overlay.of(context).insert(_dropdownOverlay!); //Insere na tela
  }

  void _removerDropdown() {
    _dropdownOverlay?.remove(); //Remove da tela
    _dropdownOverlay = null;
  }

  void _atualizarFiltro(String texto) {
    // Filtra a lista com base no texto
    setState(() {
      cidadesFiltradas = todasCidades
          .where((hab) => hab.toLowerCase().contains(texto.toLowerCase()))
          .toList();
    });

    // Atualiza o dropdown se já estiver visível
    if (_dropdownOverlay != null) {
      _removerDropdown();
      _dropdownOverlay = _criarDropdownOverlay();
      Overlay.of(context).insert(_dropdownOverlay!);
    }
  }

  OverlayEntry _criarDropdownOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width - 40, //Largura do dropdown alinhada ao TextField
        child: CompositedTransformFollower(
          link: _layerLink, //Liga ao Texfield
          showWhenUnlinked: false,
          offset: const Offset(0, 60), //Distancia do TextField
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(8),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cidadesFiltradas.length,
              itemBuilder: (context, index) {
                final cidade = cidadesFiltradas[index];
                return ListTile(
                  title: Text(cidade),
                  onTap: () {
                    setState(() {
                      if (!cidadesSelecionadas.contains(cidade)) {
                        cidadesSelecionadas.add(cidade); //Adiciona
                      }
                      _searchController.clear(); //Limpa o campo
                      _removerDropdown(); //Fecha o dropdown
                      _focusNode.unfocus(); //Remove o foco
                    });
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
      onTap: () {
        _focusNode.unfocus(); //Tira o foco ao tocar fora
      },
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
                    onChanged: _atualizarFiltro, //Filtra ao digitar
                    decoration: InputDecoration(
                      labelText: 'Buscar cidade',
                      filled: true,
                      fillColor: Colors.white,
                      //labelStyle: const TextStyle(color: Color(0xFF09189F)),
                      enabledBorder: OutlineInputBorder(
                        //borderSide: const BorderSide(color: Color(0xFF09189F)),
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
                  children: cidadesSelecionadas
                      .map(
                        (hab) => Chip(
                          label: Text(hab),
                          backgroundColor: Cores.laranjaSuave,
                          labelStyle: TextStyle(color: Cores.azul),
                          deleteIconColor: Cores.azul,
                          onDeleted: () {
                            setState(() {
                              cidadesSelecionadas.remove(hab);
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          //Salvar dados no firestore
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
      ),
    );
  }
}
