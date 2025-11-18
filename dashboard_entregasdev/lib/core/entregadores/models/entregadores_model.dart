import 'package:flutter/material.dart';
import 'package:dashboard_entregasdev/theme/app_colors.dart';
class EntregadoresModel {
  final String id;
  final String nome;
  final String localizacao;
  final String statusFirestore;
  final bool online;

  EntregadoresModel({
    required this.id,
    required this.nome,
    required this.localizacao,
    required this.statusFirestore,
    required this.online,
  });

  String get status {
    if (!online) {
      return 'Offline';
    }
    
    switch (statusFirestore) {
      case 'disponivel':
        return 'Disponível';
      case 'em_coleta':
        return 'A caminho da loja';
      case 'em_entrega':
        return 'A caminho do cliente';
      default:
        return '';
    }
  }

  Color get statusColor {
    if (!online) {
      return AppColors.cinza.withValues(alpha: 0.7);
    }

    switch (statusFirestore) {
      case 'disponivel':
        return AppColors.branco.withValues(alpha: 0.9);
      case 'em_coleta':
        return Colors.orangeAccent;
      case 'em_entrega':
        return Colors.lightBlueAccent;
      default:
        return AppColors.cinza.withValues(alpha: 0.5);
    }
  }
}
