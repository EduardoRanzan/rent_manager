import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_manager/models/expenses/expenses_model.dart';
import 'package:rent_manager/models/properties/properties_model.dart';
import 'package:rent_manager/views/expenses/expenses_form_page.dart';

class ExpensesItemPage extends StatelessWidget {
  final ExpensesModel expense;
  final ThemeData theme;
  final NumberFormat currency;
  final VoidCallback onUpdate;
  final List<PropertiesModel> properties;

  const ExpensesItemPage({
    super.key,
    required this.expense,
    required this.theme,
    required this.currency,
    required this.onUpdate,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    final property = properties.where(
          (p) => p.id == expense.propertyId,
    ).isNotEmpty
        ? properties.firstWhere((p) => p.id == expense.propertyId)
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: theme.colorScheme.primaryContainer,
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),

        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.surface,
          child: const Icon(Icons.attach_money),
        ),

        title: Row(
          children: [
            Text(
              '${expense.id.toString()} - ${expense.name}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  property?.name ?? 'Sem imóvel',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                )
            )
          ]
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
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),

        onTap: () => _editExpense(context, expense),
      ),
    );
  }

  void _editExpense(BuildContext context, ExpensesModel expense) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExpensesFormPage(expense: expense),
      ),
    );

    if (result == true) {
      onUpdate();
    }
  }
}