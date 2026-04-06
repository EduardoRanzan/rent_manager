import 'package:isar/isar.dart';
import 'package:rent_manager/database/isar_service.dart';
import 'package:rent_manager/models/expenses/expenses_type_model.dart';

class ExpensesTypeRepository {
  final Isar isar = IsarService.isar;

  Future<int> save(ExpensesTypeModel type) async {
    return await isar.writeTxn(() async {
      return await isar.expensesTypeModels.put(type);
    });
  }

  Future<ExpensesTypeModel?> getById(int id) {
    return isar.expensesTypeModels.get(id);
  }

  Future<List<ExpensesTypeModel>> getAll() {
    return isar.expensesTypeModels.where().findAll();
  }
}