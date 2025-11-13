import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_entregasdev/core/auth/auth_service.dart';
import 'package:dashboard_entregasdev/core/auth/login_controller.dart';
import 'package:dashboard_entregasdev/core/auth/login_page.dart';
import 'package:dashboard_entregasdev/core/core_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(i) {
    i.add<AuthService>(() => AuthService(i.get<FirebaseAuth>()));
    i.add<LoginController>(
      () => LoginController(
        i.get<AuthService>(),
        i.get<FirebaseFirestore>(),
      ),
    );
  }

  @override
  void routes(r) => r.child('/', child: (_) => const LoginPage());
}
