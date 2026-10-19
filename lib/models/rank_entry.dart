/// Linha do ranking semanal.
class RankEntry {
  final String name;
  final int points;
  final bool isCurrentUser;

  const RankEntry({
    required this.name,
    required this.points,
    this.isCurrentUser = false,
  });

  /// Iniciais exibidas no avatar (ex.: "Marina S." -> "MS").
  String get initials => initialsOf(name);
}

/// Gera até duas iniciais a partir de um nome.
String initialsOf(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
      .toUpperCase();
}
