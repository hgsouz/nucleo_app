import 'package:flutter/material.dart';

import '../routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/nucleo_button.dart';
import '../widgets/nucleo_logo.dart';
import '../widgets/page_header.dart';

/// Tela de login / cadastro (dados mockados, sem servidor).
class LoginScreen extends StatefulWidget {
  /// Chamado quando o formulário é validado com sucesso.
  final void Function(String name) onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _registerMode = false;
  bool _hidePassword = true;
  bool _submitting = false;

  static final RegExp _emailPattern = RegExp(
    r'^[\w.+\-]+@[\w\-]+(\.[\w\-]+)+$',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ---- Validações ----------------------------------------------------------

  String? _validateName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Informe seu nome.';
    if (text.length < 3) return 'O nome precisa ter pelo menos 3 letras.';
    return null;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Informe seu e-mail.';
    if (!_emailPattern.hasMatch(text)) return 'Digite um e-mail válido.';
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Informe sua senha.';
    if (text.length < 6) return 'Use uma senha com pelo menos 6 caracteres.';
    return null;
  }

  /// "hugo.souza43@email.com" -> "Hugo Souza"
  String _nameFromEmail(String email) {
    final local = email.split('@').first;
    final parts = local
        .split(RegExp(r'[._\-+]+'))
        .map((part) => part.replaceAll(RegExp(r'\d'), ''))
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase())
        .toList();
    return parts.isEmpty ? 'Explorador' : parts.join(' ');
  }

  // ---- Ações ---------------------------------------------------------------

  Future<void> _submit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      showAppSnackBar(
        context,
        'Confira os campos destacados e tente novamente.',
        error: true,
      );
      return;
    }

    final email = _emailController.text.trim();
    final name = _registerMode
        ? _nameController.text.trim()
        : _nameFromEmail(email);

    setState(() => _submitting = true);
    widget.onLogin(name);
    showAppSnackBar(
      context,
      _registerMode
          ? 'Conta criada! Bem-vindo(a), $name.'
          : 'Acesso realizado! Redirecionando para sua jornada...',
    );

    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    // Passa o nome do usuário como parâmetro para a Home.
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
      arguments: name,
    );
  }

  void _forgotPassword() {
    final emailError = _validateEmail(_emailController.text);
    if (emailError != null) {
      showAppSnackBar(
        context,
        'Preencha um e-mail válido para recuperar a senha.',
        error: true,
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Recuperar senha',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Enviamos um link de recuperação para '
          '${_emailController.text.trim()}. (simulação)',
          style: AppText.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  void _toggleMode() {
    setState(() {
      _registerMode = !_registerMode;
      _formKey.currentState?.reset();
    });
  }

  // ---- Interface -----------------------------------------------------------

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFA8AFB8)),
      prefixIcon: Icon(icon, size: 20, color: AppColors.textMuted),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(
        children: [
          // Brilho azul no topo.
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 410,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.4, -0.8),
                  radius: 0.9,
                  colors: [
                    AppColors.blueBright.withValues(alpha: 0.38),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 24),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SquareIconButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Voltar',
                    dark: true,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ),
                _buildBrand(),
                _buildCard(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
                  child: Text(
                    'Ao continuar, você concorda com os Termos de Uso e '
                    'Privacidade.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      height: 1.5,
                      color: Color(0xFF95A6BA),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrand() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 28),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const NucleoLogo(size: 58),
          ),
          const SizedBox(height: 13),
          Text(
            'AMAZUL APRESENTA',
            style: AppText.overline.copyWith(color: const Color(0xFF9ED2FF)),
          ),
          const SizedBox(height: 5),
          const Text(
            'Núcleo',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Conhecimento que gera um futuro melhor.',
            style: TextStyle(fontSize: 12, color: Color(0xFFB9C6D5)),
          ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(21, 25, 21, 25),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 55,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _registerMode ? 'Criar conta' : 'Boas-vindas',
              style: AppText.h1.copyWith(fontSize: 23),
            ),
            const SizedBox(height: 4),
            Text(
              _registerMode
                  ? 'Preencha seus dados para começar.'
                  : 'Entre para continuar sua jornada.',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 22),
            if (_registerMode) ...[
              _label('Nome'),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: _validateName,
                decoration: _decoration(
                  hint: 'Como podemos te chamar?',
                  icon: Icons.person_outline,
                ),
              ),
              const SizedBox(height: 15),
            ],
            _label('E-mail'),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: _validateEmail,
              decoration: _decoration(
                hint: 'voce@exemplo.com',
                icon: Icons.mail_outline,
              ),
            ),
            const SizedBox(height: 15),
            _label('Senha'),
            TextFormField(
              controller: _passwordController,
              obscureText: _hidePassword,
              textInputAction: TextInputAction.done,
              validator: _validatePassword,
              onFieldSubmitted: (_) => _submitting ? null : _submit(),
              decoration: _decoration(
                hint: 'Sua senha',
                icon: Icons.lock_outline,
                suffix: IconButton(
                  tooltip: _hidePassword ? 'Mostrar senha' : 'Ocultar senha',
                  icon: Icon(
                    _hidePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                  onPressed: () =>
                      setState(() => _hidePassword = !_hidePassword),
                ),
              ),
            ),
            if (_registerMode)
              FormField<bool>(
                initialValue: false,
                validator: (accepted) => accepted == true
                    ? null
                    : 'Aceite os termos para criar a conta.',
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: field.value ?? false,
                          activeColor: AppColors.blue,
                          onChanged: (checked) => field.didChange(checked),
                        ),
                        const Expanded(
                          child: Text(
                            'Li e aceito os Termos de Uso.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          field.errorText!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            else
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _forgotPassword,
                  child: const Text(
                    'Esqueci minha senha',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            NucleoButton(
              label: _registerMode ? 'Cadastrar' : 'Entrar',
              trailingIcon: Icons.arrow_forward_rounded,
              onPressed: _submitting ? null : _submit,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 17),
              child: Row(
                children: [
                  Expanded(child: Divider(color: Color(0xFFDDD6D6))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'ou',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xFFDDD6D6))),
                ],
              ),
            ),
            NucleoButton(
              label: _registerMode ? 'Já tenho uma conta' : 'Criar uma conta',
              variant: ButtonVariant.secondary,
              onPressed: _submitting ? null : _toggleMode,
            ),
          ],
        ),
      ),
    );
  }
}
