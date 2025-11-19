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

    final presenceStream = _database.ref('presence/entregadores').onValue;
    final locationStream = _database.ref('entregadores_localizacao').onValue;

    return Rx.combineLatest3(
      fsStream,
      presenceStream,
      locationStream,
      (
        QuerySnapshot<Map<String, dynamic>> snap,
        DatabaseEvent presenceEvent,
        DatabaseEvent locationEvent,
      ) {
        final rawPresence = presenceEvent.snapshot.value;
        final rawLocation = locationEvent.snapshot.value;

        final presenceMap = rawPresence is Map ? rawPresence : <dynamic, dynamic>{};
        final locationMap = rawLocation is Map ? rawLocation : <dynamic, dynamic>{};

        return snap.docs.map((doc) {
          final data = doc.data();

          final presence = presenceMap[doc.id] as Map<dynamic, dynamic>?;
          final bool isOnline = presence?['state'] == 'online';

          final loc = locationMap[doc.id] as Map<dynamic, dynamic>?;

          String localizacaoTexto;

          if (loc != null) {
            final rua = loc['rua'] as String?;
            if (rua != null && rua.trim().isNotEmpty) {
              localizacaoTexto = rua;
            } 
            else if (loc['lat'] != null && loc['lon'] != null) {
              final lat = (loc['lat'] as num).toDouble();
              final lon = (loc['lon'] as num).toDouble();
              localizacaoTexto =
                  '${lat.toStringAsFixed(5)}, ${lon.toStringAsFixed(5)}';
            } 
            else {
              localizacaoTexto = data['localizacao'] ?? '-';
            }
          } else {
            localizacaoTexto = data['localizacao'] ?? '-';
          }

          final String statusEntrega = data['status'] ?? 'disponivel';

          return EntregadoresModel(
            id: doc.id,
            nome: data['nome'] ?? 'Sem nome',
            localizacao: localizacaoTexto,
            statusFirestore: statusEntrega,
            online: isOnline,
          );
        }).toList();
      },
    );
  }
}
