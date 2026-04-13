import 'package:flutter/cupertino.dart';
import 'package:rent_manager/views/dashboard/dashboard_page.dart';
import 'package:rent_manager/views/expenses/expenses_page.dart';
import 'package:rent_manager/views/expenses/type/expenses_type_form.dart';
import 'package:rent_manager/views/home/home_page.dart';
import 'package:rent_manager/views/login/login_page.dart';
import 'package:rent_manager/views/profile/profile_page.dart';
import 'package:rent_manager/views/properties/properties_page.dart';
import 'package:rent_manager/views/reports/report_page.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> initRoutes() {
    return {
      '/home': (context) => HomePage(),
      '/dashboard': (context) => DashboardPage(),
      '/expenses': (context) => ExpensesPage(),
      '/properties': (context) => PropertiesPage(),
      '/report': (context) => ReportPage(),
      '/profile': (context) => ProfilePage(),
      '/login': (context) => LoginPage(),
      '/expenses-type': (context) => ExpensesTypeForm(),
    };
  }
}