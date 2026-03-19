import 'package:flutter/material.dart';
import 'package:rent_manager/core/routes/app_routes.dart';
import 'package:rent_manager/core/theme/app_theme.dart';
import 'package:rent_manager/views/home/home_page.dart';

void main() {
  runApp(const RentManagerApp());
}

class RentManagerApp extends StatelessWidget {
  const RentManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rent Manager',
      theme: AppTheme.initTheme(),
      routes: AppRoutes.initRoutes(),
      initialRoute: HomePage.routeName,
      debugShowCheckedModeBanner: false,
    );
  }
}
