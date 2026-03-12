import 'package:flutter/material.dart';
import 'package:rent_manager/core/routes/app_routes.dart';
import 'package:rent_manager/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.initTheme(),
      routes: AppRoutes.initRoutes(),
      initialRoute: '/home',
    );
  }
}
