import 'package:dashboard_entregasdev/core/auth/auth_service.dart';
import 'package:flutter/cupertino.dart';

class HomeController extends ChangeNotifier {
  final AuthService _auth;
  HomeController(this._auth);

  Future<void> logout() async {
    await _auth.signOut();
  }
}
