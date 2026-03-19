import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_manager/models/expenses/expenses_model.dart';
import 'package:rent_manager/models/expenses/expenses_type_model.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  static String routeName = '/expenses';

  @override
  State<StatefulWidget> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final List<ExpensesModel> expenses = [
    ExpensesModel(id: '1', name: 'Luz', type: ExpensesTypeModel(id: '1', icon: Icon(Icons.flash_on, color: Colors.yellow,), name: 'Energia', color: Colors.yellow), value: 100, date: DateTime.now(), deadline: DateTime.now(), propertieId: ''),
    ExpensesModel(id: '1', name: 'Água', type: ExpensesTypeModel(id: '1', icon: Icon(Icons.water_drop, color: Colors.blue,), name: 'Água', color: Colors.blue), value: 100, date: DateTime.now(), deadline: DateTime.now(), propertieId: ''),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];

          return Card(
            color: expense.type.color.withOpacity(0.5),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.surface,
                child: expense.type.icon,
              ),
              title: Text(
                expense.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Data: ${DateFormat('dd/MM/yyyy').format(expense.date)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    'Vencimento: ${DateFormat('dd/MM/yyyy').format(expense.deadline)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              trailing: Text(
                currency.format(expense.value),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: expense.type.color.withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(
          Icons.add,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}