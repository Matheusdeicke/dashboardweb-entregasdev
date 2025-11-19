import 'package:dashboard_entregasdev/core/solicitacoes/models/solicitacao_model.dart';
import 'package:dashboard_entregasdev/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DashboardSection extends StatelessWidget {
  final Stream<int> entregadoresOnlineStream;
  final Stream<int> totalSolicitacoesStream;
  final Stream<List<SolicitacaoModel>> pedidosEmAndamentoStream;

  const DashboardSection({
    super.key,
    required this.entregadoresOnlineStream,
    required this.totalSolicitacoesStream,
    required this.pedidosEmAndamentoStream,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
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
                "DASHBOARD",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: AppColors.cinza,
                  letterSpacing: 1.2,
                ),
              ),
              Icon(Icons.dashboard, color: AppColors.cinza, size: 28),
            ],
          ),

          const SizedBox(height: 40),

          Row(
            children: [
              StreamBuilder<int>(
                stream: entregadoresOnlineStream,
                initialData: 0,
                builder: (context, snapshot) {
                  final online = snapshot.data ?? 0;
                  return _cardStats(
                    title: "Entregadores online",
                    value: online.toString(),
                    cardColor: AppColors.cardColor,
                    textColor: AppColors.cinza,
                  );
                },
              ),
              const SizedBox(width: 20),
              StreamBuilder<int>(
                stream: totalSolicitacoesStream,
                initialData: 0,
                builder: (context, snapshot) {
                  final total = snapshot.data ?? 0;
                  return _cardStats(
                    title: "Total de solicitações",
                    value: total.toString(),
                    cardColor: AppColors.cardColor,
                    textColor: AppColors.cinza,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 40),

          Center(
            child: Text(
              "PEDIDOS EM ANDAMENTO",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.cinza,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: StreamBuilder<List<SolicitacaoModel>>(
              stream: pedidosEmAndamentoStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final pedidos = snapshot.data ?? [];

                if (pedidos.isEmpty) {
                  return Center(
                    child: Text(
                      "Nenhum pedido em andamento",
                      style: TextStyle(color: AppColors.cinza),
                    ),
                  );
                }

                return GridView.builder(
                  itemCount: pedidos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 2,
                  ),
                  itemBuilder: (context, index) {
                    final pedido = pedidos[index];
                    return _cardPedidos(
                      pedido,
                      AppColors.cardColor,
                      AppColors.cinza,
                      AppColors.cinza,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardStats({
    required String title,
    required String value,
    required Color cardColor,
    required Color textColor,
  }) {
    return Container(
      width: 250,
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
              Icon(Icons.arrow_outward, size: 16, color: Colors.grey[500]),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardPedidos(
    SolicitacaoModel pedido,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    final entregador = pedido.entregadorNome ?? 'O entregador';

    String linha1;
    switch (pedido.status) {
      case 'em_coleta':
        linha1 = '$entregador está a caminho da loja';
        break;
      case 'em_entrega':
        linha1 = '$entregador está a caminho do cliente';
        break;
      case 'finalizada':
        linha1 = '$entregador finalizou a entrega';
        break;
      default:
        linha1 = 'Aguardando entregador aceitar a solicitação';
    }

    final double distanciaKm = pedido.distanciaKm ?? 8.0;
    final bool indoParaLoja = pedido.status == 'em_coleta';
    final String destinoTexto = indoParaLoja
        ? 'para o entregador chegar na loja'
        : 'para o entregador chegar no cliente';

    final String linha2 = '${distanciaKm.toStringAsFixed(1)} km $destinoTexto';

    final String endereco = (pedido.enderecoTexto.isEmpty
        ? 'Endereço não informado'
        : pedido.enderecoTexto);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
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
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
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
                    linha1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    linha2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subTextColor.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    endereco,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subTextColor.withOpacity(0.9),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _extrairRua(String endereco) {
    final partes = endereco.split(',');
    return partes.isNotEmpty ? partes.first : endereco;
  }

  String statusLegivel(String status) {
    switch (status) {
      case 'em_coleta':
        return 'A caminho da loja';
      case 'em_entrega':
        return 'A caminho do cliente';
      default:
        return status;
    }
  }
}
