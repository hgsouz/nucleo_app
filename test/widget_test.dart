import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nucleo_app/main.dart';
import 'package:nucleo_app/widgets/bottom_nav.dart';

/// Simula um celular alto, para que todos os itens das listas sejam
/// construídos e fiquem visíveis durante o teste.
void useTallPhone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 4000);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

/// Abre a tela "Banco de perguntas" pela barra inferior da Home.
Future<void> openQuestions(WidgetTester tester) async {
  await tester.pumpWidget(const NucleoApp());
  await tester.tap(
    find.descendant(
      of: find.byType(NucleoBottomNav),
      matching: find.text('Perguntas'),
    ),
  );
  await tester.pumpAndSettle();
}

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

  testWidgets('Cards de benefícios da Home não estouram com fonte grande', (
    tester,
  ) async {
    useTallPhone(tester);
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const NucleoApp());
    await tester.pumpAndSettle();

    expect(find.text('Saúde'), findsWidgets);
    // Qualquer "BOTTOM OVERFLOWED" aparece aqui como exceção.
    expect(tester.takeException(), isNull);
  });

  testWidgets('Barra inferior abre o banco de perguntas com AppBar', (
    tester,
  ) async {
    useTallPhone(tester);
    await openQuestions(tester);

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Banco de perguntas'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets('Envia o id da pergunta para a tela de explicação', (
    tester,
  ) async {
    useTallPhone(tester);
    await openQuestions(tester);

    // Primeira pergunta do mock (id 1): "emite fumaça poluente" -> Mito.
    await tester.tap(find.text('Explicação').first);
    await tester.pumpAndSettle();

    expect(find.text('POR QUÊ?'), findsOneWidget);
    expect(
      find.text('A energia nuclear emite fumaça poluente na atmosfera.'),
      findsOneWidget,
    );
    expect(find.text('É MITO'), findsOneWidget);

    // Botão voltar da explicação retorna ao banco de perguntas.
    await tester.tap(find.text('Voltar ao banco de perguntas'));
    await tester.pumpAndSettle();

    expect(find.text('Banco de perguntas'), findsOneWidget);
  });

  testWidgets('Formulário de pergunta valida e publica com SnackBar', (
    tester,
  ) async {
    useTallPhone(tester);
    await openQuestions(tester);

    await tester.tap(find.text('Nova pergunta'));
    await tester.pumpAndSettle();

    // Envia vazio: mostra as mensagens de validação.
    await tester.tap(find.text('Publicar pergunta'));
    await tester.pumpAndSettle();

    expect(find.text('Escreva a afirmação.'), findsOneWidget);
    expect(find.text('Escreva a explicação.'), findsOneWidget);

    // Preenche corretamente e publica.
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Usinas nucleares geram eletricidade o dia todo.',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Elas funcionam dia e noite, sem depender de sol ou vento.',
    );
    await tester.tap(find.text('Publicar pergunta'));
    await tester.pumpAndSettle();

    expect(find.text('Nova pergunta adicionada ao jogo.'), findsOneWidget);
    expect(
      find.text('Usinas nucleares geram eletricidade o dia todo.'),
      findsOneWidget,
    );
  });

  testWidgets('Excluir pergunta pede confirmação e avisa com SnackBar', (
    tester,
  ) async {
    useTallPhone(tester);
    await openQuestions(tester);

    await tester.tap(find.text('Excluir').first);
    await tester.pumpAndSettle();

    expect(find.text('Excluir pergunta?'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Excluir'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pergunta removida.'), findsOneWidget);
    expect(
      find.text('A energia nuclear emite fumaça poluente na atmosfera.'),
      findsNothing,
    );
  });
}
