import 'package:dashboard_entregasdev/app_module.dart';
import 'package:dashboard_entregasdev/app_widget.dart';
import 'package:dashboard_entregasdev/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}