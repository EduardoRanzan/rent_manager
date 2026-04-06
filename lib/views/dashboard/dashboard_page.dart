import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_manager/models/expenses/expenses_model.dart';
import 'package:rent_manager/models/expenses/expenses_type_model.dart';
import 'package:rent_manager/models/properties/properties_model.dart';
import 'package:rent_manager/models/properties/properties_type_model.dart';
import 'package:rent_manager/views/expenses/expenses_item_page.dart';
import 'package:rent_manager/views/expenses/expenses_page.dart';
import 'package:rent_manager/views/properties/properties_item_page.dart';
import 'package:rent_manager/views/properties/properties_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static String routeName = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 15,
          children: [
            _buildFinanceCard(theme),
            _buildPropertiesCard(theme),
            _buildExpensesCard(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceCard(ThemeData theme) {
    return Card(
      color: Colors.white70.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _financeItem(
              theme,
              'A receber',
              'R\$ 5.000',
              theme.colorScheme.tertiary,
            ),
            _financeItem(
              theme,
              'Recebido',
              'R\$ 12.000',
              theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _financeItem(
      ThemeData theme,
      String title,
      String value,
      Color color,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPropertiesCard(ThemeData theme) {

    final List<PropertiesModel> properties = [];

    return Card(
      color: Colors.white70.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                child: Text(
                  'Imóveis',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(PropertiesPage.routeName);
                },
              )
            ),

            const SizedBox(height: 12),

            ...properties.map((property) {
              return PropertiesItemPage(property: property);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesCard(ThemeData theme) {
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    final expenses = [];

    return Card(
      color: Colors.white70.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(ExpensesPage.routeName);
                },
                child: Text(
                  'Despesas',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ...expenses.map((expense) {
              return ExpensesItemPage(expense: expense, theme: theme, currency: currency);
            }),
          ],
        ),
      ),
    );
  }
}