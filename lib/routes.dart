import 'package:flutter/material.dart';

/// Nomes das rotas do aplicativo.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String myth = '/mito';
  static const String city = '/cidade';
  static const String login = '/login';
  static const String questions = '/perguntas';
}

/// Navegação da barra inferior.
///
/// - A partir da Home, a tela escolhida é empilhada (o botão voltar retorna).
/// - Entre abas, a tela atual é substituída.
/// - Para "Início", a pilha é limpa e a Home volta a ser a primeira tela.
void navigateToTab(BuildContext context, String current, String target) {
  if (current == target) return;
  final navigator = Navigator.of(context);
  if (target == AppRoutes.home) {
    navigator.pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  } else if (current == AppRoutes.home) {
    navigator.pushNamed(target);
  } else {
    navigator.pushReplacementNamed(target);
  }
}
