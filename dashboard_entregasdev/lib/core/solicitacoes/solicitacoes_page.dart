import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_entregasdev/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:dashboard_entregasdev/core/solicitacoes/novasolicitacao_dialog.dart';

class SolicitacoesPage extends StatefulWidget {
  const SolicitacoesPage({super.key});

  @override
  State<SolicitacoesPage> createState() => _SolicitacoesPageState();
}

class _SolicitacoesPageState extends State<SolicitacoesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        color: AppColors.bgColor,
      ),
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SOLICITAÇÕES',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColors.cinza,
                  letterSpacing: 1.2,
                ),
              ),
              Icon(Icons.list_alt, color: AppColors.cinza, size: 28),
            ],
          ),
          const SizedBox(height: 24),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Stack(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('solicitacoes')
                        .orderBy('data_criacao', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'Nenhuma solicitação disponível',
                            style: TextStyle(
                              color: AppColors.cinza,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      final docs = snapshot.data!.docs;

                      return GridView.builder(
                        padding: const EdgeInsets.only(top: 20, bottom: 80),
                        itemCount: docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 2,
                            ),
                        itemBuilder: (context, index) {
                          final doc = docs[index];
                          final data = doc.data() as Map<String, dynamic>;

                          final endereco = data['endereco_texto'] ?? '';
                          final status = data['status'] ?? 'pendente';
                          final entregadorNome = data['entregador_nome'];

                          return _cardSolicitacao(
                            endereco: endereco,
                            status: status,
                            entregadorNome: entregadorNome,
                          );
                        },
                      );
                    },
                  ),

                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cinza, width: 2),
                        color: Colors.transparent,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add, color: AppColors.cinza),
                        iconSize: 32,
                        onPressed: _abrirNovaSolicitacaoDialog,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _abrirNovaSolicitacaoDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const NovaSolicitacaoDialog(),
    );
  }
}

Widget _cardSolicitacao({
  required String endereco,
  required String status,
  String? entregadorNome,
}) {
  final bool pendente = status == 'pendente';

  return Opacity(
    opacity: pendente ? 0.4 : 1.0,
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Text(
                _extrairRua(endereco),
                style: TextStyle(
                  color: AppColors.cinza,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    statusLegivel(status),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.cinza,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    status == 'pendente'
                        ? "Status: Pendente"
                        : "Entregador: ${entregadorNome ?? '--'}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.cinza.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

String _extrairRua(String endereco) {
  final partes = endereco.split(',');
  return partes.isNotEmpty ? partes.first : endereco;
}

String statusLegivel(String status) {
  switch (status) {
    case 'pendente':
      return 'Aguardando entregador';
    case 'em_coleta':
      return 'A caminho da loja';
    case 'em_entrega':
      return 'A caminho do cliente';
    case 'finalizada':
      return 'Entrega finalizada';
    default:
      return status;
  }
}
