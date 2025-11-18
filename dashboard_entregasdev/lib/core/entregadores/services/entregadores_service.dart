import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dashboard_entregasdev/core/entregadores/models/entregadores_model.dart';

class EntregadoresService {
  final FirebaseFirestore _firestore;
  final FirebaseDatabase _database;

  EntregadoresService(this._firestore, this._database);

  Stream<List<EntregadoresModel>> getEntregadoresStream() {
    final fsStream = _firestore
        .collection('users')
        .where('role', isEqualTo: 'entregador')
        .snapshots();

    final rtStream = _database.ref('presence/entregadores').onValue;

    return Rx.combineLatest2(
      fsStream,
      rtStream,
      (QuerySnapshot<Map<String, dynamic>> snap, DatabaseEvent event) {
        final presenceMap = event.snapshot.value as Map? ?? {};

        return snap.docs.map((doc) {
          final data = doc.data();

          final presence = presenceMap[doc.id] as Map<dynamic, dynamic>?;

          final bool isOnline = presence?['state'] == 'online';

          return EntregadoresModel(
            id: doc.id,
            nome: data['nome'] ?? 'Sem nome',
            localizacao: data['localizacao'] ?? '-',
            statusFirestore: data['status'] ?? 'indefinido',
            online: isOnline,
          );
        }).toList();
      },
    );
  }
}
