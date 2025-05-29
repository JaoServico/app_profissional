import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/cores.dart';

class Rodape extends StatelessWidget {
  const Rodape({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Cores.laranjaSuave,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildRodapeItem(
              icon: Icons.home,
              label: "Inicio",
              onTap: () {
                if (ModalRoute.of(context)?.settings.name != '/') {
                  Navigator.pushNamed(context, '/');
                }
              },
            ),
            _buildRodapeItem(
              icon: Icons.person,
              label: "Perfil",
              onTap: () {
                if (ModalRoute.of(context)?.settings.name != '/perfilPage') {
                  Navigator.pushNamed(context, '/perfilPage');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // função helper:
  Widget _buildRodapeItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Cores.azul,
            size: 24, // menor que o 30 que estava
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Cores.azul,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
