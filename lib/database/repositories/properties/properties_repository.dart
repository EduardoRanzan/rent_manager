import 'package:isar/isar.dart';
import 'package:rent_manager/database/isar_service.dart';
import 'package:rent_manager/models/properties/properties_model.dart';

class PropertiesRepository {
  final Isar isar = IsarService.isar;

  Future<int> save(PropertiesModel type) async {
    return await isar.writeTxn(() async {
      return await isar.propertiesModels.put(type);
    });
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() async {
      await isar.propertiesModels.delete(id);
    });
  }

  Future<List<PropertiesModel>> getAll() {
    return isar.propertiesModels.where().findAll();
  }

  Future<PropertiesModel?> getById(int id) {
    return isar.propertiesModels.get(id);
  }
}