import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_manager/models/expenses/expenses_model.dart';
import 'package:rent_manager/models/expenses/expenses_type_model.dart';
import 'package:rent_manager/views/expenses/expenses_item_page.dart';

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

          return ExpensesItemPage(expense: expense, theme: theme, currency: currency);
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