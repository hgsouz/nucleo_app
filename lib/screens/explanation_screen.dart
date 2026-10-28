import 'package:flutter/material.dart';

import '../models/question.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/nucleo_button.dart';

/// Tela de explicação de uma pergunta.
///
/// Recebe por parâmetro o [questionId] (enviado pela tela de perguntas via
/// `Navigator.pushNamed(..., arguments: id)`) e busca a pergunta na lista.
class ExplanationScreen extends StatelessWidget {
  final int? questionId;
  final List<Question> questions;

  const ExplanationScreen({
    super.key,
    required this.questionId,
    required this.questions,
  });

  Question? _find() {
    for (final question in questions) {
      if (question.id == questionId) return question;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final question = _find();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Explicação', style: AppText.h2),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: [
            if (question == null)
              const SoftCard(
                padding: EdgeInsets.all(22),
                child: Text(
                  'Pergunta não encontrada. Ela pode ter sido removida.',
                  textAlign: TextAlign.center,
                  style: AppText.body,
                ),
              )
            else
              _buildContent(question),
            const SizedBox(height: 18),
            NucleoButton(
              label: 'Voltar ao banco de perguntas',
              leadingIcon: Icons.arrow_back_rounded,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(Question question) {
    final isTrue = question.answer;
    final accent = isTrue ? AppColors.green : AppColors.red;
    final accentPale = isTrue ? AppColors.greenPale : AppColors.redPale;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.navy.withValues(alpha: 0.06)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentPale,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isTrue ? Icons.check_circle_outline : Icons.cancel_outlined,
                    color: accent,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Pill(
                  isTrue ? 'É VERDADE' : 'É MITO',
                  background: accentPale,
                  foreground: accent,
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text('AFIRMAÇÃO', style: AppText.overline),
            const SizedBox(height: 6),
            Text(question.statement, style: AppText.h2),
            const SizedBox(height: 20),
            const Divider(height: 1, color: Color(0xFFEEE7E7)),
            const SizedBox(height: 20),
            const Text('POR QUÊ?', style: AppText.overline),
            const SizedBox(height: 6),
            Text(question.explanation, style: AppText.body),
          ],
        ),
      ),
    );
  }
}
