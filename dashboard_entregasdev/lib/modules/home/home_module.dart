import 'package:dashboard_entregasdev/core/core_module.dart';
import 'package:dashboard_entregasdev/core/home/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];
  
  @override

  @override
  void routes(r) => r.child('/', child: (_) => const HomePage());
}
