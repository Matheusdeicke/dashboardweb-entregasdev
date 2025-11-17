import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_entregasdev/core/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginController {
  final AuthService _authService;
  final FirebaseFirestore _firestore;

  LoginController(this._authService, this._firestore);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = ValueNotifier<bool>(false);
  final errorMessage = ValueNotifier<String?>(null);

  Future<void> login() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        throw AuthException("E-mail e senha são obrigatórios.");
      }

      // Login normal no Firebase Auth
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = _authService.currentUser;
      if (user == null) {
        throw AuthException('Falha ao obter usuário autenticado.');
      }

      // Busca o doc no users
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        await _authService.signOut();
        throw AuthException(
          'Usuário sem cadastro de loja.',
        );
      }

      final data = doc.data()!;
      final role = data['role'] as String?;

      if (role != 'loja') {
        await _authService.signOut();
        throw AuthException(
          'Apenas contas de loja podem acessar o dashboard.',
        );
      }

      Modular.to.navigate('/home');
    } on AuthException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Ocorreu um erro inesperado.';
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isLoading.dispose();
    errorMessage.dispose();
  }
}
