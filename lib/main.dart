import 'package:flutter/material.dart';

import 'routes.dart';
import 'screens/city_game_screen.dart';
import 'screens/home_screen.dart';
import 'screens/myth_game_screen.dart';
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
      case AppRoutes.home:
      default:
        builder = (context) => ListenableBuilder(
          listenable: _state,
          builder: (context, _) => HomeScreen(
            userName: _state.userName,
            xp: _state.xp,
            mythProgress: _state.mythProgress,
            cityProgress: _state.cityProgress,
            ranking: _state.ranking,
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
