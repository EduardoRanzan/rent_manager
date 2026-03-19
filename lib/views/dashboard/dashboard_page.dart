import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_manager/models/expenses/expenses_model.dart';
import 'package:rent_manager/models/expenses/expenses_type_model.dart';
import 'package:rent_manager/views/expenses/expenses_page.dart';

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
            _buildTopProperties(theme),
            _buildExpensesCard(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceCard(ThemeData theme) {
    return Card(
      elevation: 4,
      color: theme.colorScheme.primaryContainer,
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

  Widget _buildTopProperties(ThemeData theme) {
    final properties = [
      {'name': 'Casa A', 'value': 'R\$ 4.000'},
      {'name': 'Ap 202', 'value': 'R\$ 3.200'},
      {'name': 'Studio Centro', 'value': 'R\$ 2.800'},
    ];

    return Card(
      elevation: 4,
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Imóveis',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...properties.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.onSecondaryContainer,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: theme.colorScheme.secondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(item['name']!),
                trailing: Text(
                  item['value']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesCard(ThemeData theme) {
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    final expenses = [
      ExpensesModel(
        id: '1',
        name: 'Luz',
        type: ExpensesTypeModel(
          id: '1',
          icon: Icon(Icons.flash_on, color: Colors.yellow),
          name: 'Energia',
          color: Colors.yellow,
        ),
        value: 100,
        date: DateTime.now(),
        deadline: DateTime.now(),
        propertieId: '',
      ),
      ExpensesModel(
        id: '2',
        name: 'Água',
        type: ExpensesTypeModel(
          id: '2',
          icon: Icon(Icons.water_drop, color: Colors.blue),
          name: 'Água',
          color: Colors.blue,
        ),
        value: 80,
        date: DateTime.now(),
        deadline: DateTime.now(),
        propertieId: '',
      ),
    ];

    return Card(
      elevation: 4,
      color: theme.colorScheme.tertiaryContainer,
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
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                color: expense.type.color.withOpacity(0.2),
                elevation: 0,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),

                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.surface,
                    child: expense.type.icon,
                  ),

                  title: Text(
                    expense.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    DateFormat('dd/MM').format(expense.date),
                    style: theme.textTheme.bodySmall,
                  ),

                  trailing: Text(
                    currency.format(expense.value),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: expense.type.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}