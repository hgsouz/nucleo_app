import 'package:flutter/foundation.dart';

import '../data/mock_data.dart';
import '../models/question.dart';
import '../models/rank_entry.dart';

/// Dados compartilhados entre as telas (usuário, XP, progresso e perguntas).
///
/// Nesta Sprint os dados são mockados e ficam apenas em memória.
/// Cada tela atualiza a própria interface com `setState` e avisa o
/// [AppState] quando precisa compartilhar algo com as demais telas
/// (ex.: XP ganho em um jogo aparece no ranking da Home).
class AppState extends ChangeNotifier {
  final List<Question> _questions = List<Question>.of(initialQuestions);

  int _xp = initialXp;
  String? _userName;
  int _mythProgress = 68;
  int _cityProgress = 25;

  int get xp => _xp;
  String? get userName => _userName;
  int get mythProgress => _mythProgress;
  int get cityProgress => _cityProgress;
  List<Question> get questions => List<Question>.unmodifiable(_questions);

  /// Ranking semanal ordenado, incluindo a pontuação do usuário.
  List<RankEntry> get ranking {
    final list = <RankEntry>[
      ...mockRanking,
      RankEntry(
        name: 'Você',
        points: _xp,
        isCurrentUser: true,
        avatarText: _userName == null ? 'VC' : initialsOf(_userName!),
      ),
    ];
    list.sort((a, b) => b.points.compareTo(a.points));
    return list;
  }

  void addXp(int amount) {
    if (amount <= 0) return;
    _xp += amount;
    notifyListeners();
  }

  void login(String name) {
    _userName = name;
    notifyListeners();
  }

  void setMythProgress(int percent) {
    _mythProgress = percent.clamp(0, 100);
    notifyListeners();
  }

  void setCityProgress(int percent) {
    _cityProgress = percent.clamp(0, 100);
    notifyListeners();
  }

  // ---- CRUD de perguntas -------------------------------------------------

  void addQuestion({
    required String statement,
    required bool answer,
    required String explanation,
  }) {
    _questions.add(
      Question(
        id: DateTime.now().microsecondsSinceEpoch,
        statement: statement,
        answer: answer,
        explanation: explanation,
      ),
    );
    notifyListeners();
  }

  void updateQuestion(
    int id, {
    required String statement,
    required bool answer,
    required String explanation,
  }) {
    final index = _questions.indexWhere((q) => q.id == id);
    if (index == -1) return;
    _questions[index] = _questions[index].copyWith(
      statement: statement,
      answer: answer,
      explanation: explanation,
    );
    notifyListeners();
  }

  void removeQuestion(int id) {
    _questions.removeWhere((q) => q.id == id);
    notifyListeners();
  }
}
