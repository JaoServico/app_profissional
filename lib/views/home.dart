import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jao_servico_profissional/models/rodape.dart';
import 'package:jao_servico_profissional/cores.dart';
import 'package:jao_servico_profissional/controllers/auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  Future<Map<String, dynamic>?> _getUserData() async {
    if (uid == null) return null;
    final doc = await FirebaseFirestore.instance
        .collection("profissionais")
        .doc(uid)
        .get();
    return doc.data();
  }

  /// Função para criar itens do Drawer
  Widget _buildDrawerItem(IconData icon, String title, String rota) {
    return ListTile(
      leading: Icon(icon, color: Cores.azul),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      onTap: () {
        Navigator.pushNamed(context, '/$rota');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getUserData(),
      builder: (context, snapshot) {
        final userData = snapshot.data ?? {};
        final nomeUsuario = userData["nome"] ?? "Usuário";
        final fotoUsuario = userData["foto"];

        return Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Container(
              padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
              decoration: const BoxDecoration(color: Cores.laranja),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: Icon(Icons.menu, size: 40, color: Cores.azul),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 80, // ajustado para não cortar
                    ),
                  ],
                ),
              ),
            ),
          ),
          drawer: SafeArea(
            child: Drawer(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 20),
                    color: Cores.laranjaSuave,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: fotoUsuario != null
                              ? NetworkImage(fotoUsuario)
                              : null,
                          child: fotoUsuario == null
                              ? Icon(Icons.person, color: Cores.azul, size: 50)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            nomeUsuario,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Cores.azul,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildDrawerItem(
                            Icons.edit, "Editar perfil", "perfilPage"),
                        _buildDrawerItem(Icons.thumb_up, "Siga-nos", ""),
                        _buildDrawerItem(Icons.chat, "Suporte", ""),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, color: Cores.azul),
                    title: Text("Sair", style: TextStyle(color: Cores.azul)),
                    onTap: () async {
                      await AuthService().logout();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/loginPage');
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          body: snapshot.connectionState != ConnectionState.done
              ? Container(
                  color: Cores.laranjaMuitoSuave,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  color: Cores.laranjaMuitoSuave,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Olá, $nomeUsuario!",
                        style: TextStyle(
                          color: Cores.azul,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Seja muito bem vindo ao App Jão Serviços - Profissional",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Cores.azul,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // 🔽 Card centralizado
                      Expanded(
                        child: Center(
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.lightbulb,
                                      color: Cores.laranja, size: 50),
                                  const SizedBox(width: 16),
                                  SizedBox(
                                    width: 220,
                                    child: Text(
                                      "Mantenha seu perfil sempre atualizado para ter mais chances de ser encontrado!",
                                      style: TextStyle(
                                        color: Cores.azul,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 🔽 Atalhos rápidos
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          _shortcutButton(Icons.person, "Perfil", "perfilPage"),
                          _shortcutButton(
                              Icons.school, "Certificados", "certificados"),
                          _shortcutButton(
                              Icons.star, "Habilidades", "habilidades"),
                          _shortcutButton(Icons.people, "Contatos", "contatos"),
                          _shortcutButton(
                              Icons.business_center, "Negócios", "negocios"),
                          _shortcutButton(
                              Icons.location_on, "Cidades", "cidades"),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
          bottomNavigationBar: const Rodape(),
        );
      },
    );
  }

  /// Botões de atalho na home
  Widget _shortcutButton(IconData icon, String label, String rota) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/$rota');
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Cores.laranja,
              shape: BoxShape.circle,
              border: Border.all(color: Cores.azul, width: 2),
            ),
            child: Icon(icon, color: Cores.azul, size: 35),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Cores.azul)),
      ],
    );
  }
}
