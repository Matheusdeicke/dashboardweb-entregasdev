import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_entregasdev/core/solicitacoes/models/solicitacao_model.dart';
import 'package:latlong2/latlong.dart' as lat_lng;

class SolicitacoesService {
  final FirebaseFirestore _db;

  SolicitacoesService(this._db);

  Stream<int> totalSolicitacoesStream() {
    return _db
        .collection('solicitacoes')
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  Stream<List<SolicitacaoModel>> pedidosEmAndamentoStream() {
    final distance = const lat_lng.Distance();

    return _db
        .collection('solicitacoes')
        .where('status', whereIn: ['em_coleta', 'em_entrega'])
        .snapshots()
        .asyncMap((snap) async {
          final List<SolicitacaoModel> result = [];

          for (final doc in snap.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final GeoPoint localizacaoCliente = data['localizacao'] as GeoPoint;

            double? distanciaKm;

            final String? lojaId = data['loja_id'] as String?;
            if (lojaId != null && lojaId.isNotEmpty) {
              final lojaDoc = await _db.collection('lojas').doc(lojaId).get();
              if (lojaDoc.exists) {
                final lojaData = lojaDoc.data() as Map<String, dynamic>;
                final GeoPoint? geoLoja =
                    lojaData['localizacaoLoja'] as GeoPoint?;

                if (geoLoja != null) {
                  distanciaKm = distance.as(
                    lat_lng.LengthUnit.Kilometer,
                    lat_lng.LatLng(geoLoja.latitude, geoLoja.longitude),
                    lat_lng.LatLng(
                      localizacaoCliente.latitude,
                      localizacaoCliente.longitude,
                    ),
                  );
                }
              }
            }

            result.add(
              SolicitacaoModel(
                id: doc.id,
                localizacao: localizacaoCliente,
                enderecoTexto: data['endereco_texto'] as String? ?? '',
                status: data['status'] as String? ?? 'pendente',
                dataCriacao: data['data_criacao'] as Timestamp?,
                distanciaKm: distanciaKm,
                entregadorNome: data['entregador_nome'] as String?,
              ),
            );
          }

          return result;
        });
  }

  Stream<List<SolicitacaoModel>> todasSolicitacoesStream() {
    return _db
        .collection('solicitacoes')
        .orderBy('data_criacao', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => SolicitacaoModel.fromDoc(d)).toList(),
        );
  }
}
