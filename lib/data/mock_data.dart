import '../models/question.dart';
import '../models/rank_entry.dart';

/// Dados mockados da Sprint 1 (sem banco de dados ou serviços externos).
const List<Question> initialQuestions = [
  Question(
    id: 1,
    statement: 'A energia nuclear emite fumaça poluente na atmosfera.',
    answer: false,
    explanation:
        'O que vemos saindo das torres é vapor de água. Na geração, usinas '
        'nucleares emitem pouquíssimo carbono.',
  ),
  Question(
    id: 2,
    statement:
        'A medicina usa tecnologia nuclear para diagnosticar e tratar o câncer.',
    answer: true,
    explanation:
        'Radioterapia e exames de medicina nuclear ajudam a detectar e tratar '
        'doenças com precisão.',
  ),
  Question(
    id: 3,
    statement: 'O rejeito nuclear brilha em verde como nos desenhos.',
    answer: false,
    explanation:
        'Esse brilho é ficção. O combustível é uma cerâmica sólida, '
        'armazenada com múltiplas barreiras de proteção, como aço e concreto.',
  ),
  Question(
    id: 4,
    statement: 'Uma usina nuclear pode gerar energia dia e noite.',
    answer: true,
    explanation:
        'Ela opera continuamente, sem depender do sol ou do vento, ajudando '
        'a manter o sistema elétrico estável.',
  ),
  Question(
    id: 5,
    statement: 'Uma usina nuclear pode explodir como uma bomba atômica.',
    answer: false,
    explanation:
        'O combustível de uma usina tem uma concentração de urânio muito '
        'menor que a de uma bomba. Além disso, os reatores têm sistemas de '
        'segurança em várias camadas.',
  ),
  Question(
    id: 6,
    statement: 'Alimentos comuns, como a banana, emitem radiação natural.',
    answer: true,
    explanation:
        'A banana contém potássio, que tem uma pequena parte radioativa. '
        'A quantidade é minúscula e totalmente inofensiva: a radiação faz '
        'parte do nosso dia a dia.',
  ),
];

/// Ranking semanal fictício. A linha do usuário é calculada a partir do XP.
const List<RankEntry> mockRanking = [
  RankEntry(name: 'Marina S.', points: 2480),
  RankEntry(name: 'João P.', points: 2210),
];

/// XP inicial do usuário (mock).
const int initialXp = 1840;
