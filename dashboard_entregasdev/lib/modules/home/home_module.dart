import 'package:dashboard_entregasdev/core/auth/auth_service.dart';
import 'package:dashboard_entregasdev/core/core_module.dart';
import 'package:dashboard_entregasdev/core/home/home_controller.dart';
import 'package:dashboard_entregasdev/core/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];
  
  @override
  void binds(i) {
    i.add<AuthService>(() => AuthService(i.get<FirebaseAuth>()));
    i.addLazySingleton<HomeController>(() => HomeController(i.get<AuthService>()));
  }

  @override
  void routes(r) => r.child('/', child: (_) => const HomePage());
}