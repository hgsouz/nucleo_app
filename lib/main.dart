import 'package:flutter/material.dart';

import 'routes.dart';
import 'screens/city_game_screen.dart';
import 'screens/explanation_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/myth_game_screen.dart';
import 'screens/questions_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const NucleoApp());
}

class NucleoApp extends StatefulWidget {
  const NucleoApp({super.key});

  @override
  State<NucleoApp> createState() => _NucleoAppState();
}

class _NucleoAppState extends State<NucleoApp> {
  final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  /// Monta cada tela a partir do nome da rota.
  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    WidgetBuilder builder;

    switch (settings.name) {
      case AppRoutes.myth:
        builder = (context) => ListenableBuilder(
              listenable: _state,
              builder: (context, _) => MythGameScreen(
                questions: _state.questions,
                userName: _state.userName,
                onFinish: (score, correct, total) {
                  _state.addXp(score);
                  _state.setMythProgress(
                    total == 0 ? 0 : (correct * 100 / total).round(),
                  );
                },
              ),
            );
        break;
      case AppRoutes.city:
        builder = (context) => ListenableBuilder(
              listenable: _state,
              builder: (context, _) => CityGameScreen(
                userName: _state.userName,
                onWin: () {
                  _state.addXp(300);
                  _state.setCityProgress(100);
                },
              ),
            );
        break;
      case AppRoutes.questions:
        builder = (context) => ListenableBuilder(
              listenable: _state,
              builder: (context, _) => QuestionsScreen(
                questions: _state.questions,
                userName: _state.userName,
                onCreate: (draft) => _state.addQuestion(
                  statement: draft.statement,
                  answer: draft.answer,
                  explanation: draft.explanation,
                ),
                onUpdate: (id, draft) => _state.updateQuestion(
                  id,
                  statement: draft.statement,
                  answer: draft.answer,
                  explanation: draft.explanation,
                ),
                onDelete: _state.removeQuestion,
              ),
            );
        break;
      case AppRoutes.explanation:
        // Id da pergunta recebido como argumento da rota.
        final questionId =
            settings.arguments is int ? settings.arguments as int : null;
        builder = (context) => ListenableBuilder(
              listenable: _state,
              builder: (context, _) => ExplanationScreen(
                questionId: questionId,
                questions: _state.questions,
              ),
            );
        break;
      case AppRoutes.login:
        builder = (context) => LoginScreen(onLogin: _state.login);
        break;
      case AppRoutes.home:
      default:
        // Nome recebido como argumento da rota (vem da tela de login).
        final welcomeName =
            settings.arguments is String ? settings.arguments as String : null;
        builder = (context) => ListenableBuilder(
              listenable: _state,
              builder: (context, _) => HomeScreen(
                userName: _state.userName,
                xp: _state.xp,
                mythProgress: _state.mythProgress,
                cityProgress: _state.cityProgress,
                ranking: _state.ranking,
                welcomeName: welcomeName,
              ),
            );
    }

    return MaterialPageRoute<dynamic>(builder: builder, settings: settings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Núcleo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.home,
      onGenerateRoute: _onGenerateRoute,
      // No Web/tablet, mantém o layout de celular centralizado.
      builder: (context, child) {
        return ColoredBox(
          color: const Color(0xFFDCE3EB),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
