import 'package:isar/isar.dart';

part 'expenses_model.g.dart';

@collection
class ExpensesModel {
  Id id = Isar.autoIncrement;

  late String name;

  late int expensesTypeId;

  late double value;

  late DateTime date;

  late DateTime deadline;

  late String propertyId;
}