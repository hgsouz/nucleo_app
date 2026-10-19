import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

void main() {
  runApp(const NucleoApp());
}

class NucleoApp extends StatelessWidget {
  const NucleoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Núcleo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const Scaffold(body: Center(child: Text('Núcleo'))),
    );
  }
}
