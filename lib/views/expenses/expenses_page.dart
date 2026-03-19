import 'package:flutter/material.dart';

class ExpensesPage extends StatefulWidget{
  const ExpensesPage({super.key});

  static String routeName = '/expenses';

  @override
  State<StatefulWidget> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}