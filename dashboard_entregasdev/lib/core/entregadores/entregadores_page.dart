import 'package:dashboard_entregasdev/core/entregadores/entregadores_controller.dart';
import 'package:dashboard_entregasdev/core/entregadores/models/entregadores_model.dart';
import 'package:dashboard_entregasdev/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EntregadoresPage extends StatelessWidget {
  const EntregadoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<EntregadoresController>();

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
          // TÍTULO
          Text(
            'ENTREGADORES',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: AppColors.cinza,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),

          // TABELA
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Nome',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Localização',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Status',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white12, height: 1, thickness: 1),

                  Expanded(
                    child: StreamBuilder<List<EntregadoresModel>>(
                      stream: controller.entregadoresStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Erro ao carregar entregadores',
                              style: TextStyle(color: Colors.red[300]),
                            ),
                          );
                        }

                        final entregadores = snapshot.data ?? [];

                        if (entregadores.isEmpty) {
                          return const Center(
                            child: Text(
                              'Nenhum entregador encontrado.',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: entregadores.length,
                          separatorBuilder: (_, __) => const Divider(
                            color: Colors.white10,
                            height: 1,
                            thickness: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            final e = entregadores[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      e.nome,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      e.localizacao,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        e.status,
                                        style: TextStyle(
                                          color: e.statusColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
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

  Color statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'DISPONÍVEL':
        return Colors.greenAccent;
      case 'EM COLETA':
      case 'ENTREGANDO':
        return Colors.orangeAccent;
      case 'OFF':
      case 'OFFLINE':
      default:
        return Colors.white60;
    }
  }
}
