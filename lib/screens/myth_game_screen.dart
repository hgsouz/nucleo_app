import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/question.dart';
import '../routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/common.dart';
import '../widgets/nucleo_button.dart';
import '../widgets/nucleo_logo.dart';
import '../widgets/page_header.dart';

/// Jogo 1 — Mito ou Verdade (cartões de arrastar, estilo "Tinder").
///
/// Arrastar para a direita = Verdade | Arrastar para a esquerda = Mito.
class MythGameScreen extends StatefulWidget {
  final List<Question> questions;
  final String? userName;

  /// Chamado uma única vez ao terminar o jogo (pontos, acertos e total).
  final void Function(int score, int correct, int total) onFinish;

  const MythGameScreen({
    super.key,
    required this.questions,
    required this.userName,
    required this.onFinish,
  });

  @override
  State<MythGameScreen> createState() => _MythGameScreenState();
}

class _MythGameScreenState extends State<MythGameScreen> {
  static const int _pointsPerHit = 100;
  static const double _swipeLimit = 130;
  static const double _swipeTrigger = 70;

  int _index = 0;
  int _score = 0;
  int _correctCount = 0;
  double _dragX = 0;
  bool _dragging = false;
  bool _busy = false;

  Question get _question => widget.questions[_index];

  bool get _finished => _index >= widget.questions.length;

  // ---- Lógica do jogo ------------------------------------------------------

  Future<void> _answer(bool chosen) async {
    if (_busy || _finished) return;
    final question = _question;
    final correct = chosen == question.answer;

    setState(() {
      _busy = true;
      _dragging = false;
      _dragX = chosen ? 110 : -110;
      if (correct) {
        _score += _pointsPerHit;
        _correctCount++;
      }
    });

    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!mounted) return;

    await _showFeedback(question, correct);
    if (!mounted) return;

    final isLast = _index == widget.questions.length - 1;
    setState(() {
      _index++;
      _dragX = 0;
      _busy = false;
    });

    if (isLast) {
      widget.onFinish(_score, _correctCount, widget.questions.length);
    }
  }

  void _restart() {
    setState(() {
      _index = 0;
      _score = 0;
      _correctCount = 0;
      _dragX = 0;
      _dragging = false;
      _busy = false;
    });
  }

  // ---- Gestos de arrastar --------------------------------------------------

  void _onDragStart(DragStartDetails details) {
    if (_busy) return;
    setState(() => _dragging = true);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_busy) return;
    setState(() {
      _dragX = (_dragX + details.delta.dx)
          .clamp(-_swipeLimit, _swipeLimit)
          .toDouble();
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_busy) return;
    if (_dragX > _swipeTrigger) {
      _answer(true);
    } else if (_dragX < -_swipeTrigger) {
      _answer(false);
    } else {
      setState(() {
        _dragging = false;
        _dragX = 0;
      });
    }
  }

  // ---- Feedback ------------------------------------------------------------

  Future<void> _showFeedback(Question question, bool correct) {
    final isLast = _index == widget.questions.length - 1;

    return showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
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
                    color: correct ? AppColors.greenPale : AppColors.redPale,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    correct ? Icons.check : Icons.close,
                    size: 30,
                    color: correct ? AppColors.green : AppColors.red,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  correct ? 'RESPOSTA CERTA · +$_pointsPerHit XP' : 'QUASE LÁ',
                  style: AppText.overline,
                ),
                const SizedBox(height: 8),
                Text(
                  correct ? 'Muito bem!' : 'Vamos entender?',
                  style: AppText.h1.copyWith(fontSize: 25),
                ),
                const SizedBox(height: 8),
                Text(
                  question.explanation,
                  style: AppText.body.copyWith(height: 1.55, fontSize: 15),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: AppColors.bluePale,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 20,
                        color: AppColors.blue,
                      ),
                      const SizedBox(width: 10),
                      Text.rich(
                        TextSpan(
                          text: 'Resposta: ',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.blue,
                          ),
                          children: [
                            TextSpan(
                              text: question.answer ? 'Verdade' : 'Mito',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                NucleoButton(
                  label: isLast ? 'Ver resultado' : 'Próxima pergunta',
                  trailingIcon: Icons.arrow_forward_rounded,
                  onPressed: () => Navigator.of(sheetContext).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---- Interface -----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) return _buildEmpty();
    if (_finished) return _buildResult();
    return _buildGame();
  }

  Widget _buildEmpty() {
    return Scaffold(
      bottomNavigationBar: const NucleoBottomNav(current: AppRoutes.myth),
      body: SafeArea(
        bottom: false,
        child: ListView(
          children: [
            PageHeader(
              title: 'Mito ou verdade?',
              showBack: true,
              userName: widget.userName,
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: SoftCard(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    const Icon(
                      Icons.quiz_outlined,
                      size: 40,
                      color: AppColors.blue,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Nenhuma pergunta cadastrada ainda.',
                      textAlign: TextAlign.center,
                      style: AppText.h3,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Cadastre afirmações na aba Perguntas para jogar.',
                      textAlign: TextAlign.center,
                      style: AppText.body,
                    ),
                    const SizedBox(height: 18),
                    NucleoButton(
                      label: 'Ir para Perguntas',
                      onPressed: () => navigateToTab(
                        context,
                        AppRoutes.myth,
                        AppRoutes.questions,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGame() {
    final total = widget.questions.length;

    return Scaffold(
      bottomNavigationBar: const NucleoBottomNav(current: AppRoutes.myth),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            PageHeader(
              title: 'Mito ou verdade?',
              subtitle: 'Pergunta ${_index + 1} de $total',
              showBack: true,
              userName: widget.userName,
            ),
            _buildProgressRow(total),
            _buildSwipeStage(),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          Expanded(
            child: total <= 12
                ? Row(
                    children: [
                      for (var i = 0; i < total; i++)
                        Expanded(
                          child: Container(
                            height: 5,
                            margin: EdgeInsets.only(right: i == total - 1 ? 0 : 5),
                            decoration: BoxDecoration(
                              color: i <= _index
                                  ? AppColors.blue
                                  : const Color(0xFFE5DCDC),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                    ],
                  )
                : ProgressBar(
                    value: (_index + 1) / total,
                    height: 5,
                    track: const Color(0xFFE5DCDC),
                  ),
          ),
          const SizedBox(width: 15),
          Pill('+ $_score XP', radius: 12),
        ],
      ),
    );
  }

  Widget _buildSwipeStage() {
    return Container(
      height: 414,
      margin: const EdgeInsets.fromLTRB(22, 23, 22, 14),
      child: Stack(
        children: [
          _backCard(top: 17, angle: -4, color: const Color(0xFFE8E0E0), opacity: 0.5),
          _backCard(top: 9, angle: 3, color: const Color(0xFFF2E8E8), opacity: 1),
          Positioned.fill(child: _buildFrontCard()),
        ],
      ),
    );
  }

  Widget _backCard({
    required double top,
    required double angle,
    required Color color,
    required double opacity,
  }) {
    return Positioned(
      top: top,
      left: 14,
      right: 14,
      bottom: 8,
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: angle * math.pi / 180,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrontCard() {
    final angle = (_dragX / 18) * math.pi / 180;

    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedContainer(
        duration: _dragging ? Duration.zero : const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transformAlignment: Alignment.center,
        transform: Matrix4.translationValues(_dragX, 0, 0)..rotateZ(angle),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 34),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.navy.withValues(alpha: 0.07)),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.13),
              blurRadius: 55,
              offset: const Offset(0, 22),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.bluePale,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const NucleoLogo(size: 59),
                    ),
                    const SizedBox(height: 23),
                    const Text('ANALISE A AFIRMAÇÃO', style: AppText.overline),
                    const SizedBox(height: 15),
                    Text(
                      _question.statement,
                      textAlign: TextAlign.center,
                      style: AppText.h1.copyWith(
                        fontSize: 23,
                        height: 1.32,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 13),
                    const Text(
                      'Arraste o cartão ou use os botões abaixo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ),
            if (_dragX < -25)
              const Positioned(
                top: -3,
                left: -4,
                child: _Stamp(text: 'MITO', color: AppColors.red, angle: -8),
              ),
            if (_dragX > 25)
              const Positioned(
                top: -3,
                right: -4,
                child: _Stamp(
                  text: 'VERDADE',
                  color: AppColors.green,
                  angle: 8,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _AnswerButton(
            label: 'Mito',
            icon: Icons.close,
            color: AppColors.red,
            borderColor: const Color(0xFFF0C8C8),
            onTap: () => _answer(false),
          ),
          const Row(
            children: [
              SizedBox(width: 13, child: Divider(color: Color(0xFFC4C9D0))),
              SizedBox(width: 7),
              Text(
                'DESLIZE',
                style: TextStyle(
                  fontSize: 8,
                  letterSpacing: 1,
                  color: Color(0xFFABB2BC),
                ),
              ),
              SizedBox(width: 7),
              SizedBox(width: 13, child: Divider(color: Color(0xFFC4C9D0))),
            ],
          ),
          _AnswerButton(
            label: 'Verdade',
            icon: Icons.check,
            color: AppColors.green,
            borderColor: const Color(0xFFBDE3D5),
            onTap: () => _answer(true),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final total = widget.questions.length;

    return Scaffold(
      backgroundColor: AppColors.navy,
      bottomNavigationBar: const NucleoBottomNav(current: AppRoutes.myth),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const PageHeader(
              title: 'Desafio concluído',
              showBack: true,
              dark: true,
              showAvatar: false,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 34, 28, 28),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white.withValues(alpha: 0.08),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.white.withValues(alpha: 0.035),
                          spreadRadius: 14,
                        ),
                        BoxShadow(
                          color: AppColors.white.withValues(alpha: 0.018),
                          spreadRadius: 28,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.emoji_events_outlined,
                      size: 56,
                      color: Color(0xFFFFCF62),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'MISSÃO COMPLETA',
                    style: AppText.overline.copyWith(
                      color: const Color(0xFFA9D8FF),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Você iluminou novas ideias!',
                    textAlign: TextAlign.center,
                    style: AppText.h1.copyWith(
                      fontSize: 29,
                      height: 1.2,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Conhecimento é a melhor ferramenta para trocar receio por '
                    'decisões conscientes.',
                    textAlign: TextAlign.center,
                    style: AppText.body.copyWith(
                      height: 1.55,
                      color: const Color(0xFFB8C4D3),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    '$_score',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFFFCF62),
                    ),
                  ),
                  Text(
                    'XP conquistados · $_correctCount de $total acertos',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFB8C4D3),
                    ),
                  ),
                  const SizedBox(height: 28),
                  NucleoButton(label: 'Jogar novamente', onPressed: _restart),
                  const SizedBox(height: 5),
                  NucleoButton(
                    label: 'Voltar ao início',
                    variant: ButtonVariant.ghost,
                    foregroundColor: AppColors.white,
                    onPressed: () => navigateToTab(
                      context,
                      AppRoutes.myth,
                      AppRoutes.home,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carimbo "MITO" / "VERDADE" exibido enquanto o cartão é arrastado.
class _Stamp extends StatelessWidget {
  final String text;
  final Color color;
  final double angle;

  const _Stamp({required this.text, required this.color, required this.angle});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle * math.pi / 180,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color borderColor;
  final VoidCallback onTap;

  const _AnswerButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Responder ${label.toLowerCase()}',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.1),
                blurRadius: 42,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
