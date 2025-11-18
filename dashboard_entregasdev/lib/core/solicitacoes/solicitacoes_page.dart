import 'package:dashboard_entregasdev/core/solicitacoes/novasolicitacao_dialog.dart';
import 'package:dashboard_entregasdev/theme/app_colors.dart';
import 'package:flutter/material.dart';
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
          Text(
            'SOLICITAÇÕES',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: AppColors.cinza,
              letterSpacing: 1.2,
            ),
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
                  Center(
                    child: Text(
                      'Nenhuma solicitação disponível',
                      style: TextStyle(color: AppColors.cinza, fontSize: 16),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.cinza,
                          width: 2,
                        ),
                        color: Colors.transparent,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: AppColors.cinza,
                        ),
                        iconSize: 32,
                        onPressed: () {
                          _abrirNovaSolicitacaoDialog(context);
                        },
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

  Future<void> _abrirNovaSolicitacaoDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const NovaSolicitacaoDialog(),
    );
  }
}
