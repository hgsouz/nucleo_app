import 'package:flutter/material.dart';

void main() {
  runApp(const NucleoApp());
}

class NucleoApp extends StatelessWidget {
  const NucleoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Núcleo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text('Núcleo'))),
    );
  }
}
