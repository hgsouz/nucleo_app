import 'package:flutter/material.dart';

/// Logo do Núcleo (assets/images/logo.png).
///
/// Com [white] = true, o símbolo é pintado de branco (usado sobre fundo navy).
class NucleoLogo extends StatelessWidget {
  final double size;
  final bool white;

  const NucleoLogo({super.key, this.size = 34, this.white = false});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: white ? Colors.white : null,
      colorBlendMode: white ? BlendMode.srcIn : null,
      semanticLabel: 'Logo Núcleo',
    );
  }
}
