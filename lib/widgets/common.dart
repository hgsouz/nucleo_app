import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Título de seção: rótulo pequeno (overline) + título + widget opcional à direita.
class SectionHeading extends StatelessWidget {
  final String overline;
  final String title;
  final Widget? trailing;
  final bool dark;

  const SectionHeading({
    super.key,
    required this.overline,
    required this.title,
    this.trailing,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(overline, style: AppText.overline),
              const SizedBox(height: 5),
              Text(
                title,
                style: AppText.h2.copyWith(
                  color: dark ? AppColors.white : AppColors.navy,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Etiqueta arredondada (nível, XP, capacidade...).
class Pill extends StatelessWidget {
  final String text;
  final double radius;
  final Color background;
  final Color foreground;

  const Pill(
    this.text, {
    super.key,
    this.radius = 20,
    this.background = AppColors.bluePale,
    this.foreground = AppColors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: foreground,
        ),
      ),
    );
  }
}

/// Cartão branco com borda suave e sombra (padrão visual das listas).
class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.navy.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Barra de progresso fina (0.0 a 1.0).
class ProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color color;
  final Color track;

  const ProgressBar({
    super.key,
    required this.value,
    this.height = 4,
    this.color = AppColors.blue,
    this.track = AppColors.creamDeep,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: Container(
        height: height,
        color: track,
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: value.clamp(0.0, 1.0).toDouble(),
          child: Container(color: color),
        ),
      ),
    );
  }
}

/// Mostra uma mensagem rápida (SnackBar) na parte inferior da tela.
///
/// Com [error] = true, usa a cor de alerta e o ícone de erro.
void showAppSnackBar(BuildContext context, String message, {bool error = false}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      backgroundColor: error ? AppColors.red : AppColors.navy,
      content: Row(
        children: [
          Icon(
            error ? Icons.error_outline : Icons.check,
            color: AppColors.white,
            size: 20,
          ),
          const SizedBox(width: 9),
          Expanded(child: Text(message)),
        ],
      ),
    ),
  );
}
