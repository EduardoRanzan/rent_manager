import 'package:flutter/material.dart';

class ExpensesTypeModel {
  final String id;
  final Icon icon;
  final String name;
  final Color color;

  ExpensesTypeModel({
    required this.id,
    required this.icon,
    required this.name,
    required this.color,
  });
}