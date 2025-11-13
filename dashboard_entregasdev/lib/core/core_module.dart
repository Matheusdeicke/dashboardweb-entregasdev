import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CoreModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    i.addSingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  }
}