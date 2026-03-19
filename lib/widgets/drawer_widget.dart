import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rent_manager/views/dashboard/dashboard_page.dart';
import 'package:rent_manager/views/expenses/expenses_page.dart';
import 'package:rent_manager/views/home/home_page.dart';
import 'package:rent_manager/views/profile/profile_page.dart';
import 'package:rent_manager/views/real_estate/real_estate_page.dart';

class DrawerWidget extends StatefulWidget{
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: ListView(
            children: [
              _buildTitle('Dashboard', DashboardPage.routeName),
              _buildGroup(),
              _buildTitle('Despesas', ExpensesPage.routeName),
              _buildTitle('Imóveis', RealEstatePage.routeName),
              _buildGroup(),
              _buildTitle('Perfil', ProfilePage.routeName),
            ],
          ),
        )
    );
  }

  Widget _buildTitle(String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
    );
  }

  Widget _buildGroup() {
    return Column(
      children: [
        _buildDivider(),
      ]
    );
  }

  Widget _buildDivider() {
    return Divider();
  }
}