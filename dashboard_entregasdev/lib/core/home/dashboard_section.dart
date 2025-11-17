import 'package:dashboard_entregasdev/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DashboardSection extends StatelessWidget {
  final Stream<int> entregadoresOnlineStream;

  const DashboardSection({super.key, required this.entregadoresOnlineStream});

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
            Icon( Icons.dashboard,
                color: AppColors.cinza,
                size: 28,
              ),
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
              _cardStats(
                title: "Meus pedidos",
                value: "1",
                cardColor: AppColors.cardColor,
                textColor: AppColors.cinza,
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
            child: GridView.builder(
              itemCount: 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2,
              ),
              itemBuilder: (context, index) {
                return _cardPedidos(
                  index,
                  AppColors.cardColor,
                  AppColors.cinza,
                  AppColors.cinza,
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
    int index,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
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
                "Local de entrega - Germânia",
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
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
                    "João está no processo de coleta",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: subTextColor, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "12 km para o entregador chegar na loja",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: subTextColor, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Rua Professor Prudente, 518",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: subTextColor, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
