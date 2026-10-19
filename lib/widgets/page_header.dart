import 'package:flutter/material.dart';

import '../models/rank_entry.dart';
import '../routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'nucleo_logo.dart';

/// Cabeçalho padrão das telas: marca (ou botão voltar), avatar, título e subtítulo.
class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  /// Mostra o botão voltar no lugar da marca.
  final bool showBack;

  /// Nome do usuário logado (usado nas iniciais do avatar).
  final String? userName;

  /// Versão para fundos escuros (navy).
  final bool dark;

  final bool showAvatar;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.userName,
    this.dark = false,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = dark ? AppColors.white : AppColors.navy;

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showBack)
                  SquareIconButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Voltar',
                    dark: dark,
                    onTap: () => Navigator.of(context).maybePop(),
                  )
                else
                  const _BrandLockup(),
                if (showAvatar)
                  _Avatar(userName: userName)
                else
                  const SizedBox(width: 38),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Text(title, style: AppText.h1.copyWith(color: titleColor)),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: AppText.body.copyWith(
                fontSize: 14,
                color: dark ? const Color(0xFFB8C4D3) : AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        NucleoLogo(size: 34),
        SizedBox(width: 9),
        Text(
          'Núcleo',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? userName;

  const _Avatar({this.userName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.login),
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: userName == null
            ? const Icon(Icons.person_outline, size: 20, color: AppColors.white)
            : Text(
                initialsOf(userName!),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

/// Botão quadrado arredondado com ícone (voltar, fechar...).
class SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool dark;

  const SquareIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: dark
                ? AppColors.white.withValues(alpha: 0.08)
                : AppColors.white.withValues(alpha: 0.75),
            border: Border.all(
              color: dark
                  ? AppColors.white.withValues(alpha: 0.15)
                  : AppColors.navy.withValues(alpha: 0.1),
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: dark ? AppColors.white : AppColors.navy,
          ),
        ),
      ),
    );
  }
}
