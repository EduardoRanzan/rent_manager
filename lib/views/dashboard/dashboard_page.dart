import 'package:flutter/material.dart';

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
    return Card(
      elevation: 4,
      color: theme.colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Despesas',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.build,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Manutenção'),
              trailing: const Text('R\$ 1.200'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.lightbulb,
                color: theme.colorScheme.tertiary,
              ),
              title: const Text('Energia'),
              trailing: const Text('R\$ 800'),
            ),
          ],
        ),
      ),
    );
  }
}