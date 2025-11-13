import 'package:dashboard_entregasdev/core/auth/auth_guard.dart';
import 'package:dashboard_entregasdev/modules/auth/login_module.dart';
import 'package:dashboard_entregasdev/modules/home/home_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module{
  @override
  void routes(r) {
    r.module('/', module: LoginModule());

    r.module('/home', module: HomeModule(), guards: [AuthGuard()]);
  }
}