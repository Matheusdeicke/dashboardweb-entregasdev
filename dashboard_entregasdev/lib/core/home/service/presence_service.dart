import 'package:firebase_database/firebase_database.dart';

class PresenceService {
  final FirebaseDatabase _db;

  PresenceService(this._db);

  Stream<int> observarEntregadoresOnline() {
    final entregadoresRef = _db.ref('presence/entregadores');

    return entregadoresRef.onValue.map((event) {
      final data = event.snapshot.value;

      if (data is Map) {
        int count = 0;
        for (final value in data.values) {
          if (value is Map && value['state'] == 'online') {
            count++;
          }
        }
        return count;
      }

      return 0;
    });
  }
}
