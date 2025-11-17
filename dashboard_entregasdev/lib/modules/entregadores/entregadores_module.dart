// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dashboard_entregasdev/core/core_module.dart';
// import 'package:dashboard_entregasdev/core/entregadores/entregadores_controller.dart';
// import 'package:dashboard_entregasdev/core/entregadores/services/entregadores_service.dart';
// import 'package:flutter_modular/flutter_modular.dart';

// class EntregadoresModule extends Module {
//   @override
//   List<Module> get imports => [CoreModule()];

//   @override
//   void bind(i) {
//     i.addLazySingleton<EntregadoresService>(
//       () => EntregadoresService(i.get<FirebaseFirestore>()),
//     );
    
//     i.addLazySingleton<EntregadoresController>(
//       () => EntregadoresController(i.get<EntregadoresService>()),
//     );
//   }
// }