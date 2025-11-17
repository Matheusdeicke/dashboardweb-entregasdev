// NESSA PÁGINA É ONDE VAI FICAR AS SOLICITAÇÕES
// CADA SOLICITAÇÃO VAI TER UM WIDGET PROPRIO (CONTAINER) COM BORDAS ARREDONDADAS
// NESSA PÁGINA VAI TER UM BOTÃO DE + PARA ADICIONAR UMA NOVA SOLICITAÇÃO
// AO CLICAR NO BOTÃO VAI ABRIR UM MODAL PARA PREENCHER OS DADOS DA SOLICITAÇÃO:
// LOCAL DE ENTREGA, NÚMERO, COMPLEMENTO
// NO MODAL VAI SER POSSIVEL USAR O FLUTTER MAP PARA SELECIONAR O LOCAL DE ENTREGA
// NO WIDGET DE CADA SOLICITAÇÃO VAI TER:
// ENDEREÇO DA ENTREGA
// STATUS DA ENTREGA Exemplo: Pedro está no processo de entrega, nenhum entregador aceitou até o momento

import 'package:dashboard_entregasdev/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SolicitacoesPage extends StatelessWidget {
  const SolicitacoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        color: AppColors.bgColor,
      ),
      padding: EdgeInsets.all(32.0),
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
          SizedBox(height: 24),

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
                          width: 2
                        ),
                        color: Colors.transparent,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.add, 
                          color: AppColors.cinza
                        ),
                        iconSize: 32,
                        onPressed: () {},
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
}
