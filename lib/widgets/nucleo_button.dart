import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum ButtonVariant { primary, secondary, ghost, danger }

/// Botão padrão do aplicativo (altura 52, cantos arredondados).
class NucleoButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;

  /// Ícone exibido antes do texto.
  final IconData? leadingIcon;

  /// Ícone exibido depois do texto (ex.: seta).
  final IconData? trailingIcon;

  /// Ocupa toda a largura disponível.
  final bool expand;

  final Color? backgroundColor;
  final Color? foregroundColor;

  const NucleoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.expand = true,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    late Color background;
    late Color foreground;
    var elevation = 0.0;

    switch (variant) {
      case ButtonVariant.primary:
        background = AppColors.blue;
        foreground = AppColors.white;
        elevation = 4;
        break;
      case ButtonVariant.secondary:
        background = AppColors.bluePale;
        foreground = AppColors.blue;
        break;
      case ButtonVariant.ghost:
        background = Colors.transparent;
        foreground = AppColors.navy;
        break;
      case ButtonVariant.danger:
        background = AppColors.redPale;
        foreground = AppColors.red;
        break;
    }

    background = backgroundColor ?? background;
    foreground = foregroundColor ?? foreground;

    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        disabledBackgroundColor: background.withValues(alpha: 0.5),
        disabledForegroundColor: foreground.withValues(alpha: 0.5),
        shadowColor: AppColors.blue.withValues(alpha: 0.4),
        elevation: elevation,
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: 20),
            const SizedBox(width: 10),
          ],
          Flexible(child: Text(label, textAlign: TextAlign.center)),
          if (trailingIcon != null) ...[
            const SizedBox(width: 10),
            Icon(trailingIcon, size: 20),
          ],
        ],
      ),
    );

    if (!expand) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
