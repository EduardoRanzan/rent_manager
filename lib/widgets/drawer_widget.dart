import 'package:flutter/material.dart';
import 'package:rent_manager/views/expenses/expenses_page.dart';
import 'package:rent_manager/views/home/home_page.dart';
import 'package:rent_manager/views/profile/profile_page.dart';
import 'package:rent_manager/views/properties/properties_page.dart';
import 'package:rent_manager/views/reports/report_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        children: [
          _buildHeader(theme),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildGroup('Visão Geral'),
                _buildItem(
                  context,
                  'Dashboard',
                  Icons.dashboard,
                  HomePage.routeName,
                ),
                _buildGroup('Gestão'),
                _buildItem(
                  context,
                  'Despesas',
                  Icons.attach_money,
                  ExpensesPage.routeName,
                ),
                _buildItem(
                  context,
                  'Imóveis',
                  Icons.home,
                  PropertiesPage.routeName,
                ),
                _buildItem(
                  context,
                  'Relatórios',
                  Icons.bar_chart,
                  ReportPage.routeName,
                ),
                _buildGroup('Conta'),
                _buildProfileItem(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(15),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
      ),
      child: SizedBox(
        height: 100,
        child: Image.asset('assets/images/logo.png'),
      )
    );
  }

  Widget _buildItem(
      BuildContext context,
      String title,
      IconData icon,
      String route,
      ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(route);
      },
    );
  }

  Widget _buildGroup(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: const Text('Eduardo'),
      subtitle: const Text('Meu perfil'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(ProfilePage.routeName);
      },
    );
  }
}