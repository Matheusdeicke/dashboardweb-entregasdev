import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> transformarCoordenadasEmEndereco(double lat, double lon) async {
    if (lat == 0 && lon == 0) return 'Coordenadas inválidas';

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&zoom=18&addressdetails=1',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'dashboard_entregasdev', 
          'Accept-Language': 'pt-BR',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        final address = data['address'];

        if (address != null) {
          String rua = address['road'] ?? address['pedestrian'] ?? address['street'] ?? '';
          String numero = address['house_number'] ?? '';
          String bairro = address['suburb'] ?? address['neighbourhood'] ?? address['residential'] ?? '';
          String cidade = address['city'] ?? address['town'] ?? address['municipality'] ?? '';
          String estado = address['state'] ?? '';

          String parte1 = rua;
          if (numero.isNotEmpty) parte1 += ", $numero";
          
          String parte2 = bairro;
          if (cidade.isNotEmpty) parte2 += " - $cidade";
          if (estado.isNotEmpty) parte2 += "/$estado";

          String resultado = "";
          if (parte1.isNotEmpty) resultado += parte1;
          if (parte1.isNotEmpty && parte2.isNotEmpty) resultado += " - ";
          if (parte2.isNotEmpty) resultado += parte2;

          if (resultado.trim().isEmpty || resultado == " - ") {
             return data['display_name'] ?? "Localização sem nome";
          }

          return resultado;
        }
      }
      
      return 'Endereço não encontrado';
      
    } catch (e) {
      print('ERRO HTTP WEB: $e');
      return '${lat.toStringAsFixed(6)}, ${lon.toStringAsFixed(6)}';
    }
  }

  Future<void> salvarSolicitacao({
    required double lat,
    required double lon,
    required String enderecoCompleto,
    required String lojaId,
  }) async {
    try {
      await _firestore.collection('solicitacoes').add({
        'localizacao': GeoPoint(lat, lon),
        'endereco_texto': enderecoCompleto,
        'data_criacao': FieldValue.serverTimestamp(),
        'status': 'pendente',
        'loja_id': lojaId,
      });
    } catch (e) {
      throw Exception('Erro ao salvar solicitação: $e');
    }
  }
}