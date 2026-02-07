import 'package:flutter/material.dart';
import 'app/app_router.dart';
import 'app/app_theme.dart';

void main() {
  runApp(const NomviaApp());
}

class NomviaApp extends StatelessWidget {
  const NomviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOMVIA',
      theme: AppTheme.lightTheme,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.splash,
      debugShowCheckedModeBanner: false,
    );
  }
}
