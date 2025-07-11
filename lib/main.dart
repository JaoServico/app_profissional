import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/views/cadastro_page.dart';
import 'package:jao_servico_profissional/views/certificados.dart';
import 'package:jao_servico_profissional/views/cidades.dart';
import 'package:jao_servico_profissional/views/esqueceu_senha.dart';
import 'package:jao_servico_profissional/views/habilidades.dart';
import 'package:jao_servico_profissional/views/home.dart';
import 'package:jao_servico_profissional/views/login_page.dart';
import 'package:jao_servico_profissional/views/negocios.dart';
import 'package:jao_servico_profissional/views/perfil_page.dart';
import 'package:jao_servico_profissional/views/contatos.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
