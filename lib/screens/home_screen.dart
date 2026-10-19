import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/rank_entry.dart';
import '../routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/common.dart';
import '../widgets/nucleo_button.dart';
import '../widgets/nucleo_logo.dart';
import '../widgets/page_header.dart';

/// Tela inicial: apresentação do projeto, desafios e ranking.
class HomeScreen extends StatefulWidget {
  final String? userName;
  final int xp;

  /// Progresso (0 a 100) em cada jogo.
  final int mythProgress;
  final int cityProgress;

  /// Ranking já ordenado (maior pontuação primeiro).
  final List<RankEntry> ranking;

  /// Parâmetro recebido da tela de login (via argumentos da rota).
  /// Quando informado, exibe uma mensagem de boas-vindas.
  final String? welcomeName;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.xp,
    required this.mythProgress,
    required this.cityProgress,
    required this.ranking,
    this.welcomeName,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int get _level => widget.xp ~/ 500 + 1;

  @override
  void initState() {
    super.initState();
    final name = widget.welcomeName;
    if (name != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showAppSnackBar(context, 'Bem-vindo(a), $name!');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NucleoBottomNav(current: AppRoutes.home),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            PageHeader(
              title: 'Energia para descobrir',
              subtitle: 'Ciência clara. Escolhas conscientes.',
              userName: widget.userName,
            ),
            const _HeroCard(),
            const SizedBox(height: 32),
            const _AboutSection(),
            _ChallengesSection(
              level: _level,
              mythProgress: widget.mythProgress,
              cityProgress: widget.cityProgress,
            ),
            _RankingSection(
              ranking: widget.ranking,
              userName: widget.userName,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints(minHeight: 372),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.1),
            blurRadius: 42,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Brilho azul no canto inferior direito.
          Positioned(
            right: -60,
            bottom: -40,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.blueBright.withValues(alpha: 0.55),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.66],
                ),
              ),
            ),
          ),
          // Anel decorativo.
          Positioned(
            right: -76,
            bottom: -88,
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.13),
                ),
              ),
            ),
          ),
          // Símbolo do átomo (logo em branco).
          const Positioned(
            right: 4,
            bottom: 16,
            child: Opacity(opacity: 0.88, child: NucleoLogo(size: 102, white: true)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 29, 24, 29),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: Color(0xFFA9D8FF),
                    ),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Text(
                        'CONHECIMENTO QUE TRANSFORMA',
                        style: AppText.overline.copyWith(
                          color: const Color(0xFFA9D8FF),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FractionallySizedBox(
                  widthFactor: 0.82,
                  child: Text(
                    'O futuro da energia começa sem medo.',
                    style: AppText.h1.copyWith(
                      fontSize: 31,
                      height: 1.12,
                      letterSpacing: -1.2,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FractionallySizedBox(
                  widthFactor: 0.72,
                  child: Text(
                    'Explore jogos rápidos, descubra como a tecnologia nuclear '
                    'já faz parte da sua vida e acumule pontos.',
                    style: AppText.body.copyWith(
                      color: const Color(0xFFCBD5E1),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                NucleoButton(
                  label: 'Começar jornada',
                  trailingIcon: Icons.arrow_forward_rounded,
                  expand: false,
                  backgroundColor: AppColors.blueBright,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.myth),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Benefit {
  final IconData icon;
  final String title;
  final String text;

  const _Benefit(this.icon, this.title, this.text);
}

/// Explicação do projeto + benefícios da tecnologia nuclear (GridView).
class _AboutSection extends StatelessWidget {
  const _AboutSection();

  static const List<_Benefit> _benefits = [
    _Benefit(
      Icons.medical_services_outlined,
      'Saúde',
      'Exames de imagem e radioterapia ajudam a diagnosticar e tratar o câncer.',
    ),
    _Benefit(
      Icons.eco_outlined,
      'Energia limpa',
      'Gera eletricidade com baixíssimas emissões de carbono.',
    ),
    _Benefit(
      Icons.bolt,
      'Sempre ligada',
      'Funciona dia e noite, sem depender do sol ou do vento.',
    ),
    _Benefit(
      Icons.restaurant_outlined,
      'Alimentos',
      'A radiação ajuda a conservar alimentos e a combater pragas.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            overline: 'SOBRE O PROJETO',
            title: 'Por que o Núcleo existe?',
          ),
          const SizedBox(height: 12),
          const Text(
            'A Amazul trabalha com tecnologia nuclear e sabe que ainda há muita '
            'desinformação e medo sobre o assunto. O Núcleo transforma esse '
            'conhecimento em jogos curtos, para que qualquer pessoa descubra, '
            'de forma leve, como a energia nuclear está presente na saúde, na '
            'indústria e na produção de eletricidade limpa.',
            style: AppText.body,
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _benefits.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 148,
            ),
            itemBuilder: (context, index) {
              final benefit = _benefits[index];
              return Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: AppColors.white.withValues(alpha: 0.85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: AppColors.navy.withValues(alpha: 0.06),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.bluePale,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          benefit.icon,
                          size: 20,
                          color: AppColors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        benefit.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        benefit.text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.35,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ChallengesSection extends StatelessWidget {
  final int level;
  final int mythProgress;
  final int cityProgress;

  const _ChallengesSection({
    required this.level,
    required this.mythProgress,
    required this.cityProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Column(
        children: [
          SectionHeading(
            overline: 'CONTINUE APRENDENDO',
            title: 'Escolha um desafio',
            trailing: Pill('Nível $level'),
          ),
          const SizedBox(height: 16),
          _ChallengeCard(
            icon: Icons.sports_esports_outlined,
            iconBackground: AppColors.bluePale,
            iconColor: AppColors.blue,
            title: 'Mito ou verdade?',
            subtitle: 'Deslize, responda e descubra',
            progress: mythProgress,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.myth),
          ),
          const SizedBox(height: 12),
          _ChallengeCard(
            icon: Icons.location_city_outlined,
            iconBackground: AppColors.navy,
            iconColor: AppColors.white,
            title: 'Equilíbrio da cidade',
            subtitle: 'Energia limpa, estável e acessível',
            progress: cityProgress,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.city),
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final int progress;
  final VoidCallback onTap;

  const _ChallengeCard({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SoftCard(
        radius: 19,
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 26, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.small,
                  ),
                  const SizedBox(height: 8),
                  ProgressBar(value: progress / 100),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Text(
              '$progress%',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankingSection extends StatelessWidget {
  final List<RankEntry> ranking;
  final String? userName;

  const _RankingSection({required this.ranking, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Column(
        children: [
          const SectionHeading(
            overline: 'COMUNIDADE',
            title: 'Ranking da semana',
            trailing: Icon(
              Icons.emoji_events_outlined,
              size: 25,
              color: AppColors.amber,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.navy.withValues(alpha: 0.06)),
            ),
            child: Column(
              children: [
                for (var i = 0; i < ranking.length; i++)
                  _RankRow(
                    position: i + 1,
                    entry: ranking[i],
                    isLast: i == ranking.length - 1,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _InviteCard(userName: userName),
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  final int position;
  final RankEntry entry;
  final bool isLast;

  const _RankRow({
    required this.position,
    required this.entry,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    Color avatarColor = AppColors.navySoft;
    if (position == 1) {
      avatarColor = AppColors.amber;
    } else if (entry.isCurrentUser) {
      avatarColor = AppColors.blue;
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: entry.isCurrentUser ? AppColors.bluePale : null,
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppColors.navy.withValues(alpha: 0.06),
                ),
              ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text(
              '$position',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              entry.initials,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              entry.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            '${formatPoints(entry.points)} XP',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class _InviteCard extends StatelessWidget {
  final String? userName;

  const _InviteCard({required this.userName});

  String get _code {
    final base = userName == null ? 'EXPLORADOR' : initialsOf(userName!);
    return 'NUCLEO-$base-150';
  }

  Future<void> _openDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.cream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Convide amigos',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cada novo explorador que se cadastrar com o seu código rende '
                '150 XP. Ao convidar 5 amigos, você desbloqueia uma skin '
                'exclusiva de átomo dourado.',
                style: AppText.body,
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.bluePale,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  _code,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: AppColors.blue,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Fechar'),
            ),
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: _code));
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
                if (context.mounted) {
                  showAppSnackBar(context, 'Código copiado!');
                }
              },
              child: const Text('Copiar código'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDialog(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bluePale,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.blue.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add, color: AppColors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Convide amigos',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 2),
                  Text('Ganhe 150 XP por novo explorador', style: AppText.small),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}
