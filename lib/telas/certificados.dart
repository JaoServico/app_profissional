import 'package:flutter/material.dart';
import 'package:jao_servico_profissional/cores.dart';

class CertificadosPage extends StatefulWidget {
  const CertificadosPage({super.key});

  @override
  _CertificadosPageState createState() => _CertificadosPageState();
}

class _CertificadosPageState extends State<CertificadosPage> {
  final List<Map<String, String>> _certificados = [
    {'nome': 'Certificado Flutter', 'data': 'Jan 2025'},
    {'nome': 'Certificado Dart', 'data': 'Mar 2024'},
  ];

  // Função para adicionar um novo certificado à lista
  void _adicionarCertificado() {
    setState(() {
      // Adiciona um certificado vazio à lista
      _certificados.add({'nome': '', 'data': ''});
    });
  }

  // Função para remover um certificado baseado no índice
  void _removerCertificado(int index) {
    setState(() {
      // Remove o certificado da lista
      _certificados.removeAt(index);
    });
  }

  // Função para simular o salvamento dos certificados (por enquanto só imprime)
  void _salvarCertificados() {
    // Aqui você pode salvar os certificados no Firestore
    print('Certificados Salvos: $_certificados');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7EAD8), // Cor de fundo laranjaMuitoSuave
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
              20.0), // Padding para dar espaçamento nas bordas
          child: Column(
            children: [
              // Título da página
              Text(
                "Certificados e Formações",
                style: TextStyle(
                  fontSize: 24,
                  color: Cores.azul, // Azul
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8), // Espaçamento
              const Text(
                "Cadastre ou edite seus certificados e formações",
                style: TextStyle(fontSize: 16, color: Cores.preto),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16), // Espaçamento
              Expanded(
                // Lista de certificados, que pode ser rolada para cima e para baixo
                child: ListView.builder(
                  itemCount: _certificados.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // Linha para o ícone de excluir
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Cores.vermelho),
                                  onPressed: () => _removerCertificado(
                                      index), // Remove o certificado
                                ),
                              ],
                            ),
                            // Campo de nome do certificado
                            TextField(
                              controller: TextEditingController(
                                text: _certificados[index]['nome'],
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Nome do Certificado',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),

                              maxLines:
                                  null, // Permite que o texto quebre a linha
                              onChanged: (value) {
                                setState(() {
                                  // Atualiza o nome do certificado
                                  _certificados[index]['nome'] = value;
                                });
                              },
                            ),
                            const SizedBox(
                                height: 10), // Espaçamento entre os campos
                            // Campo de data de conclusão
                            TextField(
                              controller: TextEditingController(
                                text: _certificados[index]['data'],
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Data de Conclusão',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  // Atualiza a data do certificado
                                  _certificados[index]['data'] = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20), // Espaçamento
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _adicionarCertificado,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Cores.laranja, // Cor laranja
                        foregroundColor: Cores.azul, // Cor azul
                        side: BorderSide(color: Cores.azul, width: 2),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 32),
                      ),
                      child: const Text(
                        "Adicionar Certificado",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Espaçamento
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
    );
  }
}
