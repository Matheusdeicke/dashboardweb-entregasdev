import 'package:cloud_firestore/cloud_firestore.dart';

class SolicitacaoModel {
  final String id;
  final GeoPoint localizacao;
  final String enderecoTexto;
  final String status;
  final Timestamp? dataCriacao;
  final double? distanciaKm;
  final String? entregadorNome;

  SolicitacaoModel({
    required this.id,
    required this.localizacao,
    required this.enderecoTexto,
    required this.status,
    required this.dataCriacao,
    this.distanciaKm,
    this.entregadorNome,
  });

  factory SolicitacaoModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SolicitacaoModel(
      id: doc.id,
      localizacao: data['localizacao'] as GeoPoint,
      enderecoTexto: data['endereco_texto'] as String? ?? '',
      status: data['status'] as String? ?? 'pendente',
      dataCriacao: data['data_criacao'] as Timestamp?,
      distanciaKm: (data['distancia_km'] as num?)?.toDouble(),
      entregadorNome: data['entregador_nome'] as String?,
    );
  }
}
