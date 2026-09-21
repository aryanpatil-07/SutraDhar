import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: SutraDharApp(),
    ),
  );
}

class SutraDharApp extends StatelessWidget {
  const SutraDharApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SutraDhar - Chola AI-TTRPG Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
