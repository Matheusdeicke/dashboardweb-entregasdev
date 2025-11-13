import 'package:dashboard_entregasdev/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SidebarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const SidebarWidget({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: AppColors.preto,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            'Entregas Dev',
            style: TextStyle(
              color: AppColors.cinza,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Menu principal',
            style: TextStyle(color: AppColors.cinza, fontSize: 16),
          ),
          
          const SizedBox(height: 40),

          _buildMenuButton(index: 0, label: 'DASHBOARD', icon: Icons.dashboard),
          _buildMenuButton(index: 1, label: 'ENTREGADORES', icon: Icons.motorcycle),
          _buildMenuButton(index: 2, label: 'SOLICITAÇÕES', icon: Icons.list_alt),
          
          const Spacer(),
          _buildMenuButton(index: 3, label: 'SAIR', icon: Icons.logout),
        ],
      ),
    );
  }

  Widget _buildMenuButton({required int index, required String label, required IconData icon}) {
    final isSelected = selectedIndex == index;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.white : AppColors.cinza),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.cinza,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () => onIndexChanged(index),
    );
  }
}