import 'package:flutter/material.dart';

import '../routes.dart';
import '../theme/app_colors.dart';

class _NavItem {
  final String route;
  final IconData icon;
  final String label;

  const _NavItem(this.route, this.icon, this.label);
}

/// Barra de navegação inferior (Início, Mito ou fato, Cidade, Perguntas).
class NucleoBottomNav extends StatelessWidget {
  /// Rota da tela atual (destaca o item ativo).
  final String current;

  const NucleoBottomNav({super.key, required this.current});

  static const List<_NavItem> _items = [
    _NavItem(AppRoutes.home, Icons.home_outlined, 'Início'),
    _NavItem(AppRoutes.myth, Icons.sports_esports_outlined, 'Mito ou fato'),
    _NavItem(AppRoutes.city, Icons.location_city_outlined, 'Cidade'),
    _NavItem(AppRoutes.questions, Icons.edit_outlined, 'Perguntas'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAFA),
        border: Border(
          top: BorderSide(color: AppColors.navy.withValues(alpha: 0.08)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
          child: Row(
            children: [
              for (final item in _items)
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => navigateToTab(context, current, item.route),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.icon,
                            size: 22,
                            color: item.route == current
                                ? AppColors.blue
                                : const Color(0xFF8490A0),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: item.route == current
                                  ? AppColors.blue
                                  : const Color(0xFF8490A0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
