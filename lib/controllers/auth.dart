import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Função para criar conta
  Future<bool> signUp({required String email, required String senha}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return true;
    } catch (e) {
      print('Erro ao cadastrar: $e');
      return false;
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
