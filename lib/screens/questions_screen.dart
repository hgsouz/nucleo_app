import 'package:flutter/material.dart';

import '../models/question.dart';
import '../routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/common.dart';
import '../widgets/nucleo_button.dart';
import '../widgets/page_header.dart';

/// CRUD de perguntas do jogo "Mito ou Verdade" (dados em memória).
class QuestionsScreen extends StatelessWidget {
  final List<Question> questions;
  final String? userName;

  final void Function(QuestionDraft draft) onCreate;
  final void Function(int id, QuestionDraft draft) onUpdate;
  final void Function(int id) onDelete;

  const QuestionsScreen({
    super.key,
    required this.questions,
    required this.userName,
    required this.onCreate,
    required this.onUpdate,
    required this.onDelete,
  });

  /// Abre o formulário (bottom sheet). Recebe a pergunta a editar (ou null,
  /// para criar) e devolve os dados preenchidos ao fechar.
  Future<QuestionDraft?> _openForm(BuildContext context, {Question? editing}) {
    return showModalBottomSheet<QuestionDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => QuestionFormSheet(question: editing),
    );
  }

  Future<void> _create(BuildContext context) async {
    final draft = await _openForm(context);
    if (draft == null) return;
    onCreate(draft);
    if (context.mounted) {
      showAppSnackBar(context, 'Nova pergunta adicionada ao jogo.');
    }
  }

  Future<void> _edit(BuildContext context, Question question) async {
    final draft = await _openForm(context, editing: question);
    if (draft == null) return;
    onUpdate(question.id, draft);
    if (context.mounted) {
      showAppSnackBar(context, 'Pergunta atualizada com sucesso.');
    }
  }

  Future<void> _delete(BuildContext context, Question question) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Excluir pergunta?',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text('"${question.statement}"', style: AppText.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: AppColors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    onDelete(question.id);
    if (context.mounted) showAppSnackBar(context, 'Pergunta removida.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Banco de perguntas', style: AppText.h2),
        actions: [
          IconButton(
            tooltip: 'Conta',
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
          ),
          const SizedBox(width: 6),
        ],
      ),
      bottomNavigationBar: const NucleoBottomNav(current: AppRoutes.questions),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(top: 4, bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 14),
              child: Text(
                '${questions.length} itens publicados',
                style: AppText.body.copyWith(fontSize: 14),
              ),
            ),
            _buildIntro(),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: NucleoButton(
                label: 'Nova pergunta',
                leadingIcon: Icons.add,
                onPressed: () => _create(context),
              ),
            ),
            if (questions.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: SoftCard(
                  padding: EdgeInsets.all(22),
                  child: Text(
                    'Nenhuma pergunta cadastrada. Toque em "Nova pergunta" '
                    'para criar a primeira.',
                    textAlign: TextAlign.center,
                    style: AppText.body,
                  ),
                ),
              ),
            for (var i = 0; i < questions.length; i++)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                child: _QuestionItem(
                  number: i + 1,
                  question: questions[i],
                  // Envia o id da pergunta para a tela de explicação.
                  onOpen: () => Navigator.of(context).pushNamed(
                    AppRoutes.explanation,
                    arguments: questions[i].id,
                  ),
                  onEdit: () => _edit(context, questions[i]),
                  onDelete: () => _delete(context, questions[i]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.edit_outlined,
              size: 26,
              color: Color(0xFFA9D8FF),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ÁREA DO EDUCADOR',
                  style: AppText.overline.copyWith(
                    color: const Color(0xFFA9D8FF),
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Conteúdo do jogo',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Mantenha as informações claras e confiáveis.',
                  style: TextStyle(fontSize: 10, color: Color(0xFFB8C4D3)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionItem extends StatelessWidget {
  final int number;
  final Question question;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _QuestionItem({
    required this.number,
    required this.question,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isTrue = question.answer;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.navy.withValues(alpha: 0.06)),
      ),
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    number.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFB3BAC3),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isTrue ? AppColors.greenPale : AppColors.redPale,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isTrue ? 'VERDADE' : 'MITO',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                        color: isTrue ? AppColors.green : AppColors.red,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Text(question.statement, style: AppText.h3),
              const SizedBox(height: 8),
              Text(
                question.explanation,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.5,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 15),
              const Divider(height: 1, color: Color(0xFFEEE7E7)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ActionChip(
                    icon: Icons.menu_book_outlined,
                    label: 'Explicação',
                    color: AppColors.navy,
                    background: AppColors.creamDeep,
                    onTap: onOpen,
                  ),
                  _ActionChip(
                    icon: Icons.edit_outlined,
                    label: 'Editar',
                    color: AppColors.blue,
                    background: AppColors.bluePale,
                    onTap: onEdit,
                  ),
                  _ActionChip(
                    icon: Icons.delete_outline,
                    label: 'Excluir',
                    color: AppColors.red,
                    background: AppColors.redPale,
                    onTap: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Formulário de criação/edição de pergunta (exibido em um bottom sheet).
///
/// Recebe a pergunta a ser editada pelo parâmetro [question] (nulo = criar)
/// e devolve um [QuestionDraft] por meio do `Navigator.pop`.
class QuestionFormSheet extends StatefulWidget {
  final Question? question;

  const QuestionFormSheet({super.key, this.question});

  @override
  State<QuestionFormSheet> createState() => _QuestionFormSheetState();
}

class _QuestionFormSheetState extends State<QuestionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _statementController;
  late final TextEditingController _explanationController;
  late bool _answer;
  bool _showFormError = false;

  bool get _isEditing => widget.question != null;

  @override
  void initState() {
    super.initState();
    _statementController = TextEditingController(
      text: widget.question?.statement ?? '',
    );
    _explanationController = TextEditingController(
      text: widget.question?.explanation ?? '',
    );
    _answer = widget.question?.answer ?? true;
  }

  @override
  void dispose() {
    _statementController.dispose();
    _explanationController.dispose();
    super.dispose();
  }

  String? _validateStatement(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Escreva a afirmação.';
    if (text.length < 12) return 'Use pelo menos 12 caracteres.';
    return null;
  }

  String? _validateExplanation(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Escreva a explicação.';
    if (text.length < 15) return 'Use pelo menos 15 caracteres.';
    return null;
  }

  void _save() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      setState(() => _showFormError = true);
      return;
    }
    Navigator.of(context).pop(
      QuestionDraft(
        statement: _statementController.text.trim(),
        answer: _answer,
        explanation: _explanationController.text.trim(),
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFA8AFB8)),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.all(13),
      errorStyle: const TextStyle(fontSize: 11, color: AppColors.red),
      enabledBorder: border(AppColors.line),
      focusedBorder: border(AppColors.blue, 1.6),
      errorBorder: border(AppColors.red),
      focusedErrorBorder: border(AppColors.red, 1.6),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _answerOption({
    required bool value,
    required IconData icon,
    required String label,
  }) {
    final selected = _answer == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _answer = value),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: selected ? AppColors.bluePale : AppColors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: selected ? AppColors.blue : AppColors.line,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? AppColors.blue : AppColors.navy,
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.blue : AppColors.navy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: media.size.height * 0.92),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      // Sobe junto com o teclado.
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 26),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6CECE),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEditing ? 'EDITAR CONTEÚDO' : 'NOVO CONTEÚDO',
                          style: AppText.overline,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _isEditing ? 'Editar pergunta' : 'Criar pergunta',
                          style: AppText.h1.copyWith(fontSize: 23),
                        ),
                      ],
                    ),
                  ),
                  SquareIconButton(
                    icon: Icons.close,
                    tooltip: 'Fechar',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 23),
              _label('Afirmação'),
              TextFormField(
                controller: _statementController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                validator: _validateStatement,
                decoration: _decoration('Ex.: A energia nuclear...'),
              ),
              const SizedBox(height: 15),
              _label('Resposta correta'),
              Row(
                children: [
                  _answerOption(
                    value: true,
                    icon: Icons.check,
                    label: 'Verdade',
                  ),
                  const SizedBox(width: 9),
                  _answerOption(
                    value: false,
                    icon: Icons.close,
                    label: 'Mito',
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _label('Explicação educativa'),
              TextFormField(
                controller: _explanationController,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                validator: _validateExplanation,
                decoration: _decoration(
                  'Explique por que a resposta está correta...',
                ),
              ),
              if (_showFormError)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 14),
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE3E3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Escreva uma afirmação e uma explicação mais completas.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: Color(0xFFA54444),
                    ),
                  ),
                ),
              const SizedBox(height: 18),
              NucleoButton(
                label: _isEditing ? 'Salvar alterações' : 'Publicar pergunta',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
