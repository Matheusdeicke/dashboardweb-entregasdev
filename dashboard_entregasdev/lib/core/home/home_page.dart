import 'package:flutter/material.dart';
import 'package:dashboard_entregasdev/theme/app_colors.dart';
import 'package:dashboard_entregasdev/widgets/sidebar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [

    const Center(
      child: Text(
        'Dashboard',
      ),
    ),

    const Center(
      child: Text(
        'Lista de Entregadores'
      )
    ),

    const Center(
      child: Text(
        'Minhas Solicitações'
      )
    ),

    const Center(
      child: Text(
        'Sair'
      )
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.preto,
      body: Row(
        children: [
          SidebarWidget(
            selectedIndex: _selectedIndex,
            onIndexChanged: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                color: AppColors.cinza,
              ),
              // não recarrega ao trocar de página
              child: IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
            ),
          )
        ],
      ),
    );
  }
}