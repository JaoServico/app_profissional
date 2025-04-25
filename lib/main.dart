import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/telas/cadastro_page.dart';
import 'package:jao_servico_profissional/telas/certificados.dart';
import 'package:jao_servico_profissional/telas/cidades.dart';
import 'package:jao_servico_profissional/telas/esqueceu_senha.dart';
import 'package:jao_servico_profissional/telas/habilidades.dart';
import 'package:jao_servico_profissional/telas/home.dart';
import 'package:jao_servico_profissional/telas/login_page.dart';
import 'package:jao_servico_profissional/telas/negocios.dart';
import 'package:jao_servico_profissional/telas/perfil_page.dart';
import 'package:jao_servico_profissional/telas/contatos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jão Serviço Profissional',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/loginPage',
      routes: {
        '/loginPage': (context) => const LoginPage(),
        '/esqueceuSenha': (context) => const EsqueceuSenha(),
        '/cadastroPage': (context) => const CadastroPage(),
        '/perfilPage': (context) => const PerfilPage(),
        '/contatos': (context) => const ContatosPage(),
        '/certificados': (context) => const CertificadosPage(),
        '/habilidades': (context) => const HabilidadesPage(),
        '/cidades': (context) => const CidadesPage(),
        '/negocios': (context) => const NegociosPage(),
        '/': (context) => const Home(),
      },
    );
  }
}
