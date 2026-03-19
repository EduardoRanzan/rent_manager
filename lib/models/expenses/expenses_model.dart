import 'package:rent_manager/models/expenses/expenses_type_model.dart';

class ExpensesModel {
  final String id;
  final String name;
  final ExpensesTypeModel type;
  final double value;
  final DateTime date;
  final DateTime deadline;
  final String propertieId;

  ExpensesModel({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.date,
    required this.deadline,
    required this.propertieId,
  });
}