import 'package:dashboard_entregasdev/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SidebarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;
  final VoidCallback onLogout;

  const SidebarWidget({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: AppColors.preto,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: const Text('Entregas DEV', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
          ),
          
          const SizedBox(height: 60),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 10),
            child: Text('Menu principal', style: TextStyle(color: Colors.grey[800], fontSize: 12)),
          ),

          _btnSidebar(index: 0, label: 'DASHBOARD', icon: Icons.dashboard_outlined),
          _btnSidebar(index: 1, label: 'ENTREGADORES', icon: Icons.motorcycle_outlined),
          _btnSidebar(index: 2, label: 'SOLICITAÇÕES', icon: Icons.flag_outlined),
          
          const Spacer(),
          
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: TextButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout, color: Colors.grey, size: 20),
              label: const Text('SAIR', style: TextStyle(color: Colors.grey)),
              style: TextButton.styleFrom(alignment: Alignment.centerLeft),
            ),
          )
        ],
      ),
    );
  }

  Widget _btnSidebar({required int index, required String label, required IconData icon}) {
    final isSelected = selectedIndex == index;
    return Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: isSelected ? BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.1), Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight
          ),
          border: const Border(left: BorderSide(color: Colors.white, width: 3))
        ) : null,
        child: ListTile(
        dense: true,
        leading: Icon(icon, color: isSelected ? Colors.white : Colors.grey[600], size: 20),
        title: Text(
            label,
            style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            letterSpacing: 1.0,
            ),
        ),
        onTap: () => onIndexChanged(index),
        ),
    );
  }
}