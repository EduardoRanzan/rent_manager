import 'package:isar/isar.dart';

part 'expenses_type_model.g.dart';

@collection
class ExpensesTypeModel {
  Id id = 0;

  late String name;

  late int iconCode;

  late int colorValue;
}