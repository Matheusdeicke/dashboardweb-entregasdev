import 'package:dashboard_entregasdev/core/auth/services/auth_service.dart';
import 'package:dashboard_entregasdev/core/home/service/presence_service.dart';
import 'package:flutter/cupertino.dart';

class HomeController extends ChangeNotifier {
  final AuthService _auth;
  final PresenceService _presenceService;

  HomeController(this._auth, this._presenceService);

  Stream<int> get entregadoresOnlineStream =>
      _presenceService.observarEntregadoresOnline();

  Future<void> logout() async {
    await _auth.signOut();
  }
}
