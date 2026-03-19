import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_manager/models/expenses/expenses_model.dart';

class ExpensesItemPage extends StatelessWidget {
  final ExpensesModel expense;
  final ThemeData theme;
  final NumberFormat currency;

  const ExpensesItemPage({
    super.key,
    required this.expense,
    required this.theme,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
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

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          style: theme.textTheme.bodyMedium?.copyWith(
            color: expense.type.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}