import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_manager/database/repositories/expenses/expenses_repository.dart';
import 'package:rent_manager/models/expenses/expenses_model.dart';
import 'package:rent_manager/models/expenses/expenses_type_model.dart';
import 'package:rent_manager/views/expenses/expenses_form_page.dart';
import 'package:rent_manager/views/expenses/expenses_item_page.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  static String routeName = '/expenses';

  @override
  State<StatefulWidget> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  late List<ExpensesModel> expenses = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      appBar: AppBar(title: Text('Despesas'),),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];

          return ExpensesItemPage(expense: expense, theme: theme, currency: currency);
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _newExpense,
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(
          Icons.add,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Future<void> _init() async {
    expenses = await ExpensesRepository().getAll();
    setState(() {});
  }

  void _newExpense({ExpensesModel? expenses}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExpensesFormPage(expense: expenses),
      ),
    );
  }
}