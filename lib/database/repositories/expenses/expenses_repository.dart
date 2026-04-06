import 'package:isar/isar.dart';
import 'package:rent_manager/database/isar_service.dart';
import 'package:rent_manager/models/expenses/expenses_model.dart';

class ExpensesRepository {
  final Isar isar = IsarService.isar;

  Future<void> save(ExpensesModel expense) async {
    await isar.writeTxn(() async {
      await isar.expensesModels.put(expense);
    });
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() async {
      await isar.expensesModels.delete(id);
    });
  }

  Future<List<ExpensesModel>> getAll() async {
    return await isar.expensesModels.where().findAll();
  }
}