import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Função para criar conta
  // Retorna null se deu certo; caso contrário, retorna a mensagem de erro.
  Future<String?> signUp({required String email, required String senha}) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );

      final uid = cred.user!.uid;

      // Cria o documento base do usuário no Firestore
      await FirebaseFirestore.instance.collection('profissionais').doc(uid).set({
        'nome': '',
        'detalhes': '',
        'fotoUrl': '',
        'email': email.trim(),
        'criadoEm': FieldValue.serverTimestamp(),
      });

      return null; // sucesso
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'E-mail já cadastrado.';
        case 'invalid-email':
          return 'E-mail inválido.';
        case 'weak-password':
          return 'Senha muito fraca (mínimo 6 caracteres).';
        case 'operation-not-allowed':
          return 'Cadastro desabilitado no projeto.';
        default:
          return 'Erro de autenticação: ${e.message ?? e.code}';
      }
    } on FirebaseException catch (e) {
      // Falha ao criar o doc no Firestore, por exemplo.
      return 'Erro ao salvar dados no Firestore: ${e.message}';
    } catch (e) {
      return 'Erro inesperado: $e';
    }
  }

  //Função para login
  Future<bool> signIn({required String email, required String senha}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return true;
    } catch (e) {
      print('Erro ao fazer login: $e');
      return false;
    }
  }

  //Função para logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  //Função para deletar a conta do usuário atual
  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }

  //Função para recuperar senha
  Future<bool> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );
      return true;
    } catch (e) {
      print("Erro ao enviar o email de recuperação: $e");
      return false;
    }
  }
}
