/// Linha do ranking semanal.
class RankEntry {
  final String name;
  final int points;
  final bool isCurrentUser;

  /// Texto do avatar. Se nulo, usa as iniciais do nome.
  final String? avatarText;

  const RankEntry({
    required this.name,
    required this.points,
    this.isCurrentUser = false,
    this.avatarText,
  });

  /// Iniciais exibidas no avatar (ex.: "Marina S." -> "MS").
  String get initials => avatarText ?? initialsOf(name);
}

/// Formata pontos no padrão brasileiro (ex.: 2480 -> "2.480").
String formatPoints(int value) {
  return value.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
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
