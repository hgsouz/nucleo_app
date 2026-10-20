import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nucleo_app/main.dart';

void main() {
  testWidgets('Home abre e navega para o jogo Mito ou Verdade', (tester) async {
    await tester.pumpWidget(const NucleoApp());

    expect(find.text('Energia para descobrir'), findsOneWidget);

    await tester.tap(find.text('Mito ou fato'));
    await tester.pumpAndSettle();

    expect(find.text('Pergunta 1 de 6'), findsOneWidget);
  });

  testWidgets('Login valida os campos do formulário', (tester) async {
    await tester.pumpWidget(const NucleoApp());

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Entrar'));
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Informe seu e-mail.'), findsOneWidget);
    expect(find.text('Informe sua senha.'), findsOneWidget);
  });
}
