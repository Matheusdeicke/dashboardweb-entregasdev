import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_entregasdev/core/entregadores/models/entregadores_model.dart';

class EntregadoresService {
  final FirebaseFirestore _firestore;

  EntregadoresService(this._firestore);

  CollectionReference get entregadoresCollection =>
      _firestore.collection('users');
  
  Stream<List<EntregadoresModel>> getEntregadoresStream() {
    return entregadoresCollection 
        .where('role', isEqualTo: 'entregador')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EntregadoresModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}