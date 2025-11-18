import 'package:dashboard_entregasdev/core/auth/services/auth_service.dart';
import 'package:dashboard_entregasdev/core/home/service/presence_service.dart';
import 'package:dashboard_entregasdev/core/solicitacoes/models/solicitacao_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:dashboard_entregasdev/core/solicitacoes/services/solicitacoes_service.dart';

class HomeController extends ChangeNotifier {
  final AuthService _auth;
  final PresenceService _presenceService;
  final SolicitacoesService _solicitacoesService;

  HomeController(this._auth, this._presenceService, this._solicitacoesService);

  Stream<int> get entregadoresOnlineStream =>
      _presenceService.observarEntregadoresOnline();

  Stream<int> get totalSolicitacoesStream =>
      _solicitacoesService.totalSolicitacoesStream();

  Stream<List<SolicitacaoModel>> get pedidosEmAndamentoStream =>
      _solicitacoesService.pedidosEmAndamentoStream();

  Future<void> logout() async {
    await _auth.signOut();
  }
}
