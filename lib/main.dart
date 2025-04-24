import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/telas/cadastro_page.dart';
import 'package:jao_servico_profissional/telas/certificados.dart';
import 'package:jao_servico_profissional/telas/esqueceu_senha.dart';
import 'package:jao_servico_profissional/telas/habilidades.dart';
import 'package:jao_servico_profissional/telas/home.dart';
import 'package:jao_servico_profissional/telas/login_page.dart';
import 'package:jao_servico_profissional/telas/perfil_page.dart';
import 'package:jao_servico_profissional/telas/redes_sociais.dart';

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
        '/redessociais': (context) => const RedesSociais(),
        '/certificados': (context) => const CertificadosPage(),
        '/habilidades': (context) => const HabilidadesPage(),
        '/': (context) => const Home(),
      },
    );
  }
}
