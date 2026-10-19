import 'package:flutter/material.dart';

/// Paleta oficial do Núcleo.
///
/// Regra 60/30/10:
///  - 60%: [cream]  (#FFF5F5) fundos e superfícies principais
///  - 30%: [blue]   (#1971C2) cor de ação, destaques e ícones
///  - 10%: [navy]   (#0B1F3A) texto, cartões de contraste e rodapés
class AppColors {
  AppColors._();

  // Paleta principal
  static const Color cream = Color(0xFFFFF5F5);
  static const Color blue = Color(0xFF1971C2);
  static const Color navy = Color(0xFF0B1F3A);

  // Variações derivadas da paleta
  static const Color creamDeep = Color(0xFFF7EAEA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color blueBright = Color(0xFF2588DF);
  static const Color bluePale = Color(0xFFE8F3FC);
  static const Color navySoft = Color(0xFF163354);

  // Texto e apoio
  static const Color textMuted = Color(0xFF667386);
  static const Color line = Color(0xFFDFD6D6);

  // Cores semânticas (feedback de acerto/erro e indicadores)
  static const Color green = Color(0xFF16835F);
  static const Color greenPale = Color(0xFFE3F5EE);
  static const Color amber = Color(0xFFD98B22);
  static const Color amberPale = Color(0xFFFFF0D5);
  static const Color red = Color(0xFFD75858);
  static const Color redPale = Color(0xFFFDEAEA);
}
