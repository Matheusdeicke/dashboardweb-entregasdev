import 'package:dashboard_entregasdev/core/home/dashboard_section.dart';
import 'package:dashboard_entregasdev/core/home/home_controller.dart';
import 'package:dashboard_entregasdev/theme/app_colors.dart';
import 'package:dashboard_entregasdev/widgets/sidebar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardSection(),
    const Center(child: Text('Lista de Entregadores')),
    const Center(child: Text('Minhas Solicitações')),
  ];

  void _logout() async {
    await controller.logout();
    Modular.to.navigate('/');
  }

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
            onLogout: _logout,
          ),
          
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                color: AppColors.cinza,
              ),
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