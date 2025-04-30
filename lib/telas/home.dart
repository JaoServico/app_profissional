import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/componentes/rodape.dart';
import 'package:jao_servico_profissional/cores.dart';
import 'package:jao_servico_profissional/servicos/auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Função para criar itens do Drawer com espaçamento e cores personalizadas
  Widget _buildDrawerItem(IconData icon, String title, String rota) {
    return ListTile(
      leading: Icon(
        icon,
        color: Cores.azul, // Ícone azul
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/$rota');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
          decoration: const BoxDecoration(
            color: Cores.laranja,
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                size: 50,
                color: Cores.azul,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //const Text("Cliente"),
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Tupã-SP",
                          style: TextStyle(
                            color: Cores.azul,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.location_on,
                          color: Cores.azul,
                          size: 22,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 100,
                      child: Container(
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Onde Estou!",
                          style: TextStyle(
                            color: Cores.azul,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 100, left: 20, bottom: 20),
              color: Cores.laranjaSuave,
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Cores.azul,
                    size: 80,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Profissional",
                    style: TextStyle(
                        fontSize: 32,
                        //fontWeight: FontWeight.bold,
                        color: Cores.azul),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(Icons.edit, "Editar perfil", "perfilPage"),
                  _buildDrawerItem(Icons.thumb_up, "Siga-nos", ""),
                  _buildDrawerItem(Icons.chat, "Suporte", ""),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Cores.azul,
              ),
              title: Text(
                "Sair",
                style: TextStyle(color: Cores.azul),
              ),
              onTap: () async {
                await AuthService().logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/loginPage');
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Cores.laranjaMuitoSuave,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Olá, Usuário!",
                        style: TextStyle(
                          color: Cores.azul,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              // Ícone
                              Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Cores.laranjaSuave,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.person, // Exemplo de ícone
                                    color: Cores.azul,
                                    size: 30,
                                  ),
                                ),
                              ),
                              //const SizedBox(height: 8),
                              // Texto "Profissional" dentro de uma caixa laranja
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Cores.laranjaSuave,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Cliente",
                                  style: TextStyle(
                                    color: Cores.azul,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              //const SizedBox(height: 8),
                              // Texto "Ir para o app" abaixo de "Profissional"
                              Text(
                                "Ir para o app",
                                style: TextStyle(
                                  color: Cores.azul,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Rodape(),
    );
  }
}
