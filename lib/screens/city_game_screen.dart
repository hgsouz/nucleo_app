import 'package:flutter/material.dart';

import '../routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/common.dart';
import '../widgets/nucleo_button.dart';
import '../widgets/page_header.dart';

/// Fontes de energia disponíveis no jogo.
enum EnergySource { solar, wind, nuclear, coal }

class _SourceInfo {
  final String name;
  final IconData icon;

  const _SourceInfo(this.name, this.icon);
}

const Map<EnergySource, _SourceInfo> _sourceInfo = {
  EnergySource.solar: _SourceInfo('Solar', Icons.wb_sunny_outlined),
  EnergySource.wind: _SourceInfo('Eólica', Icons.air),
  EnergySource.nuclear: _SourceInfo('Nuclear', Icons.bolt),
  EnergySource.coal: _SourceInfo('Carvão', Icons.factory_outlined),
};

/// Jogo 2 — Equilíbrio da Cidade.
///
/// O jogador monta a matriz energética da cidade e acompanha três barras:
/// emissão de carbono, custo da energia e estabilidade (sem apagões).
class CityGameScreen extends StatefulWidget {
  final String? userName;

  /// Chamado quando o jogador conclui a missão com a cidade equilibrada.
  final VoidCallback onWin;

  const CityGameScreen({super.key, required this.userName, required this.onWin});

  @override
  State<CityGameScreen> createState() => _CityGameScreenState();
}

class _CityGameScreenState extends State<CityGameScreen> {
  static const int _maxTotal = 8;
  static const int _maxPerSource = 3;

  final Map<EnergySource, int> _mix = {
    EnergySource.solar: 1,
    EnergySource.wind: 1,
    EnergySource.nuclear: 0,
    EnergySource.coal: 1,
  };

  int get _total => _mix.values.fold(0, (sum, value) => sum + value);

  int _count(EnergySource source) => _mix[source] ?? 0;

  // ---- Regras do jogo (valores de 0 a 100) ---------------------------------

  int get _carbon {
    final value = 18 + _count(EnergySource.coal) * 24 -
        _count(EnergySource.nuclear) * 5;
    return value.clamp(8, 100).toInt();
  }

  int get _cost {
    final value = 36 +
        _count(EnergySource.solar) * 7 +
        _count(EnergySource.wind) * 6 -
        _count(EnergySource.nuclear) * 4 +
        _count(EnergySource.coal) * 2;
    return value.clamp(15, 100).toInt();
  }

  int get _stability {
    final value = 20 +
        _count(EnergySource.nuclear) * 27 +
        _count(EnergySource.coal) * 19 +
        (_count(EnergySource.solar) + _count(EnergySource.wind)) * 5;
    return value.clamp(10, 100).toInt();
  }

  /// A cidade só fica equilibrada com energia nuclear como base estável.
  bool get _balanced =>
      _carbon <= 40 &&
      _cost <= 55 &&
      _stability >= 75 &&
      _count(EnergySource.nuclear) > 0;

  void _change(EnergySource source, int delta) {
    setState(() {
      final next = (_count(source) + delta).clamp(0, _maxPerSource).toInt();
      _mix[source] = next;
    });
  }

  // ---- Resultado -------------------------------------------------------------

  Future<void> _evaluate() async {
    final won = _balanced;
    final hasNuclear = _count(EnergySource.nuclear) > 0;

    String message;
    if (won) {
      message =
          'A energia nuclear atua como base estável e de baixo carbono, '
          'enquanto solar e eólica complementam a matriz.';
    } else if (!hasNuclear) {
      message =
          'Fontes renováveis variam com o clima. Adicione energia nuclear '
          'para garantir uma base estável sem elevar as emissões.';
    } else {
      message =
          'Reduza o carvão e combine a base nuclear com fontes renováveis '
          'para melhorar seus indicadores.';
    }

    final concluded = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: !won,
      enableDrag: !won,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 26),
          decoration: const BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: won ? AppColors.greenPale : AppColors.bluePale,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    won ? Icons.check : Icons.location_city_outlined,
                    size: 30,
                    color: won ? AppColors.green : AppColors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  won
                      ? 'CIDADE EQUILIBRADA · +300 XP'
                      : 'O CONSELHO PRECISA DE AJUSTES',
                  style: AppText.overline,
                ),
                const SizedBox(height: 8),
                Text(
                  won
                      ? 'Energia firme, limpa e acessível.'
                      : 'Sua matriz ainda não é resiliente.',
                  style: AppText.h1.copyWith(fontSize: 25),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: AppText.body.copyWith(height: 1.55, fontSize: 15),
                ),
                const SizedBox(height: 20),
                NucleoButton(
                  label: won ? 'Concluir missão' : 'Ajustar combinação',
                  onPressed: () => Navigator.of(sheetContext).pop(won),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted) return;
    if (concluded == true) {
      widget.onWin();
      navigateToTab(context, AppRoutes.city, AppRoutes.home);
    }
  }

  // ---- Interface -------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NucleoBottomNav(current: AppRoutes.city),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            PageHeader(
              title: 'Equilíbrio da cidade',
              subtitle: 'Mandato 01 · Ano 2035',
              showBack: true,
              userName: widget.userName,
            ),
            _buildCityVisual(),
            _buildDashboard(),
            _buildEnergySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCityVisual() {
    const heights = [0.48, 0.88, 0.63, 1.0, 0.72, 0.43];

    return Container(
      height: 155,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, Color(0xFF184776)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -80,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.blueBright.withValues(alpha: 0.55),
              ),
            ),
          ),
          Positioned(
            left: 18,
            top: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vila Horizonte',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${_total * 150} mil habitantes atendidos',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFB9CEE2),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 86,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final factor in heights)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          height: 86 * factor,
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 6, top: 9),
                          decoration: const BoxDecoration(
                            color: Color(0xFF08182D),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                          child: Container(
                            width: 6,
                            height: 6,
                            color: const Color(0xFFFFCF62).withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    final balanced = _balanced;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 22),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(23)),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.1),
            blurRadius: 42,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PAINEL DA CIDADE', style: AppText.overline),
                    SizedBox(height: 4),
                    Text(
                      'Indicadores de impacto',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              Pill(
                balanced ? 'Equilibrada' : 'Atenção',
                radius: 10,
                background: balanced ? AppColors.greenPale : AppColors.amberPale,
                foreground: balanced ? AppColors.green : const Color(0xFF9C6419),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _Metric(
            icon: Icons.eco_outlined,
            name: 'Emissão de carbono',
            value: _carbon,
            inverse: true,
          ),
          const SizedBox(height: 15),
          _Metric(
            icon: Icons.account_balance_wallet_outlined,
            name: 'Custo da energia',
            value: _cost,
            inverse: true,
          ),
          const SizedBox(height: 15),
          _Metric(
            icon: Icons.bolt,
            name: 'Estabilidade',
            value: _stability,
          ),
        ],
      ),
    );
  }

  Widget _buildEnergySection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
            overline: 'MATRIZ ENERGÉTICA',
            title: 'Monte sua combinação',
            trailing: Pill('$_total/$_maxTotal'),
          ),
          const SizedBox(height: 7),
          const Text(
            'Adicione fontes e encontre o equilíbrio entre segurança, custo e clima.',
            style: TextStyle(
              fontSize: 12,
              height: 1.45,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 11,
            mainAxisSpacing: 11,
            childAspectRatio: 1.2,
            children: [
              for (final source in EnergySource.values)
                _SourceCard(
                  info: _sourceInfo[source]!,
                  featured: source == EnergySource.nuclear,
                  count: _count(source),
                  canRemove: _count(source) > 0,
                  canAdd: _total < _maxTotal && _count(source) < _maxPerSource,
                  onRemove: () => _change(source, -1),
                  onAdd: () => _change(source, 1),
                ),
            ],
          ),
          const SizedBox(height: 16),
          NucleoButton(
            label: 'Avaliar minha cidade',
            trailingIcon: Icons.arrow_forward_rounded,
            onPressed: _evaluate,
          ),
        ],
      ),
    );
  }
}

/// Indicador com barra colorida (verde, âmbar ou vermelho).
class _Metric extends StatelessWidget {
  final IconData icon;
  final String name;
  final int value;

  /// Quando verdadeiro, valores menores são melhores (carbono e custo).
  final bool inverse;

  const _Metric({
    required this.icon,
    required this.name,
    required this.value,
    this.inverse = false,
  });

  @override
  Widget build(BuildContext context) {
    final quality = inverse ? 100 - value : value;
    final color = quality > 65
        ? AppColors.green
        : quality > 40
        ? AppColors.amber
        : AppColors.red;

    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textMuted),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
            Text(
              '$value%',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 7),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(end: value / 100),
          duration: const Duration(milliseconds: 300),
          builder: (context, animated, _) => ProgressBar(
            value: animated,
            height: 7,
            color: color,
            track: const Color(0xFFECE6E6),
          ),
        ),
      ],
    );
  }
}

class _SourceCard extends StatelessWidget {
  final _SourceInfo info;
  final bool featured;
  final int count;
  final bool canRemove;
  final bool canAdd;
  final VoidCallback onRemove;
  final VoidCallback onAdd;

  const _SourceCard({
    required this.info,
    required this.featured,
    required this.count,
    required this.canRemove,
    required this.canAdd,
    required this.onRemove,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: featured ? const Color(0xFFF5FAFF) : AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: featured
              ? AppColors.blue.withValues(alpha: 0.35)
              : AppColors.navy.withValues(alpha: 0.07),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (featured)
            const Positioned(
              right: 0,
              top: -5,
              child: Text(
                'RECOMENDADA',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: AppColors.blue,
                ),
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 37,
                    height: 37,
                    decoration: BoxDecoration(
                      color: AppColors.bluePale,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(info.icon, size: 20, color: AppColors.blue),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      info.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5DDDD)),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _CounterButton(
                        label: '−',
                        semantic: 'Remover ${info.name}',
                        enabled: canRemove,
                        onTap: onRemove,
                      ),
                    ),
                    SizedBox(
                      width: 38,
                      child: Text(
                        '$count',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _CounterButton(
                        label: '+',
                        semantic: 'Adicionar ${info.name}',
                        enabled: canAdd,
                        onTap: onAdd,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final String label;
  final String semantic;
  final bool enabled;
  final VoidCallback onTap;

  const _CounterButton({
    required this.label,
    required this.semantic,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: semantic,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: Opacity(
          opacity: enabled ? 1 : 0.3,
          child: Container(
            height: 34,
            alignment: Alignment.center,
            color: const Color(0xFFFBF8F8),
            child: Text(label, style: const TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }
}
