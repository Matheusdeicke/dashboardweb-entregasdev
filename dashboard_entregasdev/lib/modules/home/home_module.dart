import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_entregasdev/core/auth/services/auth_service.dart';
import 'package:dashboard_entregasdev/core/core_module.dart';
import 'package:dashboard_entregasdev/core/entregadores/entregadores_controller.dart';
import 'package:dashboard_entregasdev/core/entregadores/services/entregadores_service.dart';
import 'package:dashboard_entregasdev/core/home/home_controller.dart';
import 'package:dashboard_entregasdev/core/home/home_page.dart';
import 'package:dashboard_entregasdev/core/home/service/presence_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];
  
  @override
  void binds(i) {
    i.add<AuthService>(() => AuthService(i.get<FirebaseAuth>()));

    i.addLazySingleton<HomeController>(
      () => HomeController(
        i.get<AuthService>(),
        i.get<PresenceService>(),
      ),
    );

    i.addLazySingleton<EntregadoresService>(
      () => EntregadoresService(i.get<FirebaseFirestore>()),
    );

    i.addLazySingleton<EntregadoresController>(
      () => EntregadoresController(i.get<EntregadoresService>()),
    );
  }

  @override
  void routes(r) => r.child('/', child: (_) => const HomePage());
}
