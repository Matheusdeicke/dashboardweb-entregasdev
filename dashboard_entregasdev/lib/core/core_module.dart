import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_entregasdev/core/home/service/presence_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CoreModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    i.addSingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
    i.addSingleton<FirebaseDatabase>(() => FirebaseDatabase.instance);

    i.addSingleton<PresenceService>(
      () => PresenceService(i.get<FirebaseDatabase>()),
    );
  }
}
