/// Afirmação do jogo "Mito ou Verdade".
class Question {
  final int id;
  final String statement;

  /// `true` = Verdade, `false` = Mito.
  final bool answer;
  final String explanation;

  const Question({
    required this.id,
    required this.statement,
    required this.answer,
    required this.explanation,
  });

  Question copyWith({String? statement, bool? answer, String? explanation}) {
    return Question(
      id: id,
      statement: statement ?? this.statement,
      answer: answer ?? this.answer,
      explanation: explanation ?? this.explanation,
    );
  }
}
